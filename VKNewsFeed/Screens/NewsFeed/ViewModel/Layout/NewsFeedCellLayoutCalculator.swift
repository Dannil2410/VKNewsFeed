//
//  NewsFeedCellLayoutCalculator.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 16.10.2023.
//

import Foundation
import UIKit

protocol NewsFeedCellLayoutCalculatorProtocol {
    func sizes(
        feedText: String?,
        photoAttachments: [NewsFeedCellPhotoAttachmentModel],
        moreTextButtonPressed: Bool
    ) -> NewsFeedCellSizesModel
    
    func interactionViewSizes(feed: FeedItem) -> NewsFeedCellUserInteractionViewWidthModel
}

final class NewsFeedCellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = UIScreen.main.bounds.width) {
        self.screenWidth = screenWidth
    }
    
    func sizes(
        feedText: String?,
        photoAttachments: [NewsFeedCellPhotoAttachmentModel],
        moreTextButtonPressed: Bool
    ) -> NewsFeedCellSizesModel {
        
        var showMoreTextButton = false
        
        let cardViewWidth = screenWidth - Constants.cardViewInsets.left*2
        
        //MARK: work with postLabelFrame
        var postLabelFrame = CGRect(
            origin: CGPoint(
                x: Constants.postLabelInsets.left,
                y: Constants.postLabelInsets.top),
            size: CGSize.zero)
        
        if let text = feedText, !text.isEmpty {
            (postLabelFrame.size, showMoreTextButton) = makePostLabelFrame(text: text, cardViewWidth: cardViewWidth, moreTextButtonPressed: moreTextButtonPressed)
        }
        
        //MARK: work with moreTextButtonFrame
        var moreTextButtonFrame = CGRect(
            origin:
                CGPoint(
                    x: Constants.postLabelInsets.left,
                    y: postLabelFrame.maxY),
            size: CGSize.zero)
        
        if showMoreTextButton {
            moreTextButtonFrame.size = Constants.moreTextButtonSize
        }
        
        //MARK: work with photoAttachmentFrame
        let photoAttachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        
        var photoAttachmentFrame = CGRect(
            origin: CGPoint(
                x: 0,
                y: photoAttachmentTop),
            size: CGSize(
                width: cardViewWidth,
                height: 0)
        )
        
        if let photo = photoAttachments.first {
            let width = cardViewWidth
            let height = width * CGFloat(photo.height)/CGFloat(photo.width)
            if photoAttachments.count == 1 {
                photoAttachmentFrame.size = CGSize(width: width, height: height)
            } else if photoAttachments.count > 1{
                
                var photosSize = [CGSize]()
                
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photosSize.append(photoSize)
                }
                
                let rowHeight = RowLayout.rowHeightCounter(superViewWidth: cardViewWidth, photos: photosSize)
                photoAttachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight ?? 0)
            }
        }
        
        //MARK: work with bottomViewFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, photoAttachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(
            origin: CGPoint(
                x: 0,
                y: bottomViewTop),
            size: CGSize(
                width: cardViewWidth,
                height: Constants.bottomViewHeight)
        )
        
        //MARK: work with totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.cardViewInsets.bottom
        
        return NewsFeedCellSizes(
            postLabelFrame: postLabelFrame,
            moreTextButtonFrame: moreTextButtonFrame,
            photoAttachmentFrame: photoAttachmentFrame,
            bottomViewFrame: bottomViewFrame,
            totalHeight: totalHeight
        )
    }
    
    func interactionViewSizes(
        feed: FeedItem
    ) -> NewsFeedCellUserInteractionViewWidthModel {
        let interactionViewWidthWithoutCountLabel = Constants.userInteractionImageViewLeadingInset + Constants.userInterViewHeight*Constants.userInteractionImageViewMultiplier + Constants.countLabelTrailingInset
        
        //MARK: work with likesLabelWidth
        let likesStringWidth = FeedItem.proccess(countableItem: feed.likes)
            .width(font: Constants.userInterLabelFont)
        
        let likesViewWidth = interactionViewWidthWithoutCountLabel + likesStringWidth
        
        //MARK: work with commentsLabelWidth
        let commentsStringWidth = FeedItem.proccess(countableItem: feed.comments)
            .width(font: Constants.userInterLabelFont)
        
        let commentsViewWidth = interactionViewWidthWithoutCountLabel + commentsStringWidth
        
        //MARK: work with repostsLabelWidth
        let repostsStringWidth = FeedItem.proccess(countableItem: feed.reposts)
            .width(font: Constants.userInterLabelFont)
        
        let repostsViewWidth = interactionViewWidthWithoutCountLabel + repostsStringWidth
        
        //MARK: work with viewsLabelWidth
        let viewsStringWidth = FeedItem.proccess(countableItem: feed.views)
            .width(font: Constants.userInterLabelFont)
        
        let viewsViewWidth = interactionViewWidthWithoutCountLabel + viewsStringWidth
        
        return NewsFeedCellUserInteractionViewWidth(
            likesViewWidth: likesViewWidth,
            commentsViewWidth: commentsViewWidth,
            repostsViewWidth: repostsViewWidth,
            viewsViewWidth: viewsViewWidth
        )
    }
    
    private func makePostLabelFrame(
        text: String,
        cardViewWidth: CGFloat,
        moreTextButtonPressed: Bool
    ) ->(CGSize, Bool) {
        var showMoreTextButton = false
        let width = cardViewWidth - (Constants.postLabelInsets.left + Constants.postLabelInsets.right)
        var height = text.height(font: Constants.postLabelFont, width: width)
        
        let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
        
        if height > limitHeight && !moreTextButtonPressed {
            height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
            showMoreTextButton = true
        }
        
        let size = CGSize(width: width, height: height)
        return (size, showMoreTextButton)
    }
}
