//
//  FooterView.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 23.10.2023.
//

import UIKit
import SnapKit

final class FooterView: UIView {
    private lazy var countPostsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loadPreviousPostsIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(countPostsLabel)
        addSubview(loadPreviousPostsIndicatorView)
        
        countPostsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        
        loadPreviousPostsIndicatorView.snp.makeConstraints {
            $0.top.equalTo(countPostsLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(countPostsLabel)
        }
    }
    
    func showLoader() {
        loadPreviousPostsIndicatorView.startAnimating()
    }
    
    func setTitle(feedsCount: Int) {
        let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed posts count", comment: ""), feedsCount)
        countPostsLabel.text = footerTitle
        loadPreviousPostsIndicatorView.stopAnimating()
    }
}
