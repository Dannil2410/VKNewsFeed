//
//  Mapper.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 16.10.2023.
//

import Foundation
import UIKit

protocol NewsFeedCellModelProtocol {
    func createNewsFeedCellModel(
        for indexPath: IndexPath,
        newsFeedModel: NewsFeedResponseModel,
        moreTextButtonPressed: Bool
    ) -> NewsFeedCellModel
}

final class Mapper: NewsFeedCellModelProtocol {
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "d MMM 'в' HH:mm"
        return df
    }()
    
    private let cellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol
    
    init(cellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol = NewsFeedCellLayoutCalculator()) {
        self.cellLayoutCalculator = cellLayoutCalculator
    }
    
    func createNewsFeedCellModel(
        for indexPath: IndexPath,
        newsFeedModel: NewsFeedResponseModel,
        moreTextButtonPressed: Bool = false
    ) -> NewsFeedCellModel {
        let feed = newsFeedModel.items[indexPath.row]
        
        let profile = profiles(
            for: feed.sourceId,
            profiles: newsFeedModel.profiles,
            groups: newsFeedModel.groups
        )
        
        let topViewModel = createTopViewNewsFeedCellModel(profile: profile, date: feed.date)
        
        let photoAttachments = createNewsFeedCellPhotoAttachmentsModel(feedItem: feed)
        
        let interactionViewSizes = cellLayoutCalculator.interactionViewSizes(feed: feed)
        
        let bottomView = createBottomViewNewsFeedCellModel(feed: feed, interactionViewSizes: interactionViewSizes)
        
        let cellSizes = cellLayoutCalculator.sizes(feedText: feed.text, photoAttachments: photoAttachments, moreTextButtonPressed: moreTextButtonPressed)
        
        return Cell(
            topView: topViewModel,
            text: feed.text,
            photoAttachments: photoAttachments,
            bottomView: bottomView,
            sizes: cellSizes
        )
    }
    
    private func profiles(
        for sourceId: Int,
        profiles: [Profile],
        groups: [Group]
    ) -> ProfileRepresantable? {
        let profilesOrGroups: [ProfileRepresantable] = sourceId >= 0 ? profiles : groups
        return profilesOrGroups.filter { $0.id == abs(sourceId) }.first
    }
    
    private func createTopViewNewsFeedCellModel(
        profile: ProfileRepresantable?,
        date: Double
    ) -> TopViewNewsFeedCellModel {
        let date = Date(timeIntervalSince1970: date)
        let dateTitle = dateFormatter.string(from: date)
        
        return TopViewNewsFeedCell(
            avatarUrlString: profile?.photoUrlString ?? "",
            name: profile?.name ?? "",
            date: dateTitle
        )
    }
    
    private func createNewsFeedCellPhotoAttachmentsModel(
        feedItem: FeedItem
    ) -> [NewsFeedCellPhotoAttachmentModel] {
        guard let attachments = feedItem.attachments else { return [] }
        return attachments.compactMap { attachment -> NewsFeedCellPhotoAttachmentModel? in
            guard let photo = attachment.photo else { return nil }
            return NewsFeedCellPhotoAttachment(
                photoUrlString: photo.photoUrlString,
                width: photo.width,
                height: photo.height)
        }
    }
    
    private func createBottomViewNewsFeedCellModel(
        feed: FeedItem,
        interactionViewSizes: NewsFeedCellUserInteractionViewWidthModel
    ) -> BottomViewNewsFeedCellModel {
        BottomViewNewsFeedCell(
            likes: FeedItem.proccess(countableItem: feed.likes),
            comments: FeedItem.proccess(countableItem: feed.comments),
            reposts: FeedItem.proccess(countableItem: feed.reposts),
            views: FeedItem.proccess(countableItem: feed.views),
            interactionViewSizes: interactionViewSizes
        )
    }
}
