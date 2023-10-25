//
//  NewsFeedViewController.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import UIKit
import SnapKit
import Combine

final class NewsFeedViewController: UIViewController {
    
    //MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .purple
        return refreshControl
    }()
    
    private lazy var titleView = TitleView()
    private lazy var footerView = FooterView()
    
    private let viewModel: NewsFeedViewModel
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - init
    
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecircle
    
    override func loadView() {
        view = GradientView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigationBar()
        configureTableView()
        configureGestureRecognizer()
        viewModel.fetchNewsFeed(loadType: .firstTime)
        viewModel.fetchUserProfile()
        binding()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.reloadData()
    }
    
    //MARK: - Configurations
    
    private func configureView() {
        view.backgroundColor = .purple
    }
    
    private func configureNavigationBar() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
//        navigationController?.hidesBarsOnSwipe = true
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleView
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: NewsFeedCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = footerView
    }
    
    private func configureGestureRecognizer() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGR)
    }
    
    //MARK: Selectors
    
    @objc
    private func endEditing() {
        view.endEditing(true)
    }
    
    @objc
    private func refresh() {
        print(#function)
        viewModel.fetchNewsFeed(loadType: .new)
    }

}

//MARK: - UITableViewDataSource
extension NewsFeedViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.feedsCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.identifier, for: indexPath) as? NewsFeedCell else { fatalError() }

        let newsFeedCellModel = viewModel.newsFeedCellModel(for: indexPath)
        cell.set(viewModel: newsFeedCellModel, indexPath: indexPath)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension NewsFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let postId = viewModel.getPostId(forIndexPath: indexPath)
        return viewModel.heightForIndexPath[postId] ?? 0
    }
}

//MARK: - Binding
extension NewsFeedViewController {
    private func binding() {
        
        viewModel.updateTableViewPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] updateTableView in
                guard let self else { return }
                switch updateTableView {
                case .reloadData:
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.footerView.setTitle(feedsCount: viewModel.feedsCount)
                case let .reloadRows(indexPaths):
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: indexPaths, with: .none)
                    self.tableView.endUpdates()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$userAvatarModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userAvatarModel in
                guard let self, let avatarUrlString = userAvatarModel?.avatarUrlString else { return }
                self.titleView.set(imageUrlString: avatarUrlString)
            }
            .store(in: &cancellables)
    }
}

//MARK: - UIScrollViewDelegate
extension NewsFeedViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            footerView.showLoader()
            viewModel.fetchNewsFeed(loadType: .previous)
        }
    }
}
