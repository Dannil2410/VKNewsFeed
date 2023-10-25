//
//  NewsFeedCellModel.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 15.10.2023.
//

import Foundation

struct TopViewNewsFeedCell: TopViewNewsFeedCellModel {
    var avatarUrlString: String
    var name: String
    var date: String
}

struct NewsFeedCellPhotoAttachment: NewsFeedCellPhotoAttachmentModel {
    var photoUrlString: String
    var width: Int
    var height: Int
}

struct BottomViewNewsFeedCell: BottomViewNewsFeedCellModel {
    var likes: String
    var comments: String
    var reposts: String
    var views: String
    var interactionViewSizes: NewsFeedCellUserInteractionViewWidthModel
}

struct NewsFeedCellSizes: NewsFeedCellSizesModel {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var photoAttachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
    
    func moreTextButtonPressed(newPostLabelFrame: CGRect, newMoreTextButtonFrame: CGRect, newTotalHeight: CGFloat) -> Self {
        NewsFeedCellSizes(
            postLabelFrame: newPostLabelFrame,
            moreTextButtonFrame: newMoreTextButtonFrame,
            photoAttachmentFrame: photoAttachmentFrame,
            bottomViewFrame: bottomViewFrame,
            totalHeight: newTotalHeight)
    }
}

struct NewsFeedCellUserInteractionViewWidth: NewsFeedCellUserInteractionViewWidthModel {
    var likesViewWidth: CGFloat
    var commentsViewWidth: CGFloat
    var repostsViewWidth: CGFloat
    var viewsViewWidth: CGFloat
}

struct Cell: NewsFeedCellModel {
    var topView: TopViewNewsFeedCellModel
    var text: String?
    var photoAttachments: [NewsFeedCellPhotoAttachmentModel]
    var bottomView: BottomViewNewsFeedCellModel
    var sizes: NewsFeedCellSizesModel
}

