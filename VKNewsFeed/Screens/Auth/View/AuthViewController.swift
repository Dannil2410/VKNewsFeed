//
//  AuthViewController.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import UIKit
import WebKit
import SnapKit
import Combine

final class AuthViewController: UIViewController {
    
    //MARK: - Private properties
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    private let viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configureWebView()
        presentVkAuth()
        binding()
    }
    
    //MARK: - Configuration UI
    private func configureWebView() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
    
    private func presentVkAuth() {
        let request = viewModel.createRequest()
        
        webView.load(request)
    }
    
}

//MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        viewModel.processAccessToken(response: navigationResponse, decisionHandler: decisionHandler)
    }
}

//MARK: - Binding
extension AuthViewController {
    func binding() {
        viewModel.$dismissAuthVC
            .sink { [weak self] dismissAuthVC in
                guard let self else { return }
                if dismissAuthVC {
                    self.viewModel.moveToNewsFeedViewController()
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
