//
//  BottomView.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import UIKit
import SnapKit

final class BottomView: UIView {
    
    private lazy var likesView = UserInteractionView()
    private lazy var commentsView = UserInteractionView()
    private lazy var repostsView = UserInteractionView()
    private lazy var viewsView = UserInteractionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLikesView()
        configureCommentsView()
        configureRepostsView()
        configureviewsView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureLikesView()
        configureCommentsView()
        configureRepostsView()
        configureviewsView()
    }
    
    private func configureLikesView() {
        addSubview(likesView)
        
        likesView.setupImageView(imageName: "heart")
        
        likesView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
                .inset(Constants.userInterViewVerticalInset)
            $0.leading.equalToSuperview().inset(5)
            $0.width.equalTo(70)
        }
    }
    
    private func configureCommentsView() {
        addSubview(commentsView)
        
        commentsView.setupImageView(imageName: "bubble.left")
        
        commentsView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
                .inset(Constants.userInterViewVerticalInset)
            $0.leading.equalTo(likesView.snp.trailing).offset(10)
            $0.width.equalTo(70)
        }
        
    }
    
    private func configureRepostsView() {
        addSubview(repostsView)
        
        repostsView.setupImageView(imageName: "arrowshape.turn.up.right")
        
        repostsView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
                .inset(Constants.userInterViewVerticalInset)
            $0.leading.equalTo(commentsView.snp.trailing).offset(10)
            $0.width.equalTo(70)
        }
    }
    
    private func configureviewsView() {
        addSubview(viewsView)
        
        viewsView.setupImageView(imageName: "eye.fill")
        
        viewsView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
                .inset(Constants.userInterViewVerticalInset)
            $0.width.equalTo(70)
            $0.trailing.equalToSuperview().inset(5)
        }
    }
    
    func set(viewModel: BottomViewNewsFeedCellModel) {
        likesView.set(count: viewModel.likes)
        commentsView.set(count: viewModel.comments)
        repostsView.set(count: viewModel.reposts)
        viewsView.set(count: viewModel.views)
        
        updateUserInteractionViewsWidth(interactionViewsWidth: viewModel.interactionViewSizes)
    }
    
    private func updateUserInteractionViewsWidth(interactionViewsWidth: NewsFeedCellUserInteractionViewWidthModel) {
        
        likesView.snp.updateConstraints {
            $0.width.equalTo(interactionViewsWidth.likesViewWidth)
        }
        
        commentsView.snp.updateConstraints {
            $0.width.equalTo(interactionViewsWidth.commentsViewWidth)
        }
        
        repostsView.snp.updateConstraints {
            $0.width.equalTo(interactionViewsWidth.repostsViewWidth)
        }
        
        viewsView.snp.updateConstraints {
            $0.width.equalTo(interactionViewsWidth.viewsViewWidth)
        }
    }
}
