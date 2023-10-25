//
//  NewsFeedCellModelProtocol.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 16.10.2023.
//

import Foundation

protocol TopViewNewsFeedCellModel {
    var avatarUrlString: String { get }
    var name: String { get }
    var date: String { get }
}

protocol NewsFeedCellPhotoAttachmentModel {
    var photoUrlString: String { get }
    var width: Int { get }
    var height: Int { get }
}

protocol NewsFeedCellUserInteractionViewWidthModel {
    var likesViewWidth: CGFloat { get }
    var commentsViewWidth: CGFloat { get }
    var repostsViewWidth: CGFloat { get }
    var viewsViewWidth: CGFloat { get }
}

protocol BottomViewNewsFeedCellModel {
    var likes: String { get }
    var comments: String { get }
    var reposts: String { get }
    var views: String { get }
    var interactionViewSizes: NewsFeedCellUserInteractionViewWidthModel { get }
}

protocol NewsFeedCellSizesModel {
    var postLabelFrame: CGRect { get }
    var moreTextButtonFrame: CGRect { get }
    var photoAttachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol NewsFeedCellModel {
    var topView: TopViewNewsFeedCellModel { get }
    var text: String? { get }
    var photoAttachments: [NewsFeedCellPhotoAttachmentModel] { get }
    var bottomView: BottomViewNewsFeedCellModel { get }
    var sizes: NewsFeedCellSizesModel { get }
}
