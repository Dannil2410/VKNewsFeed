//
//  NewsFeedResponseModel.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation

struct NewsFeedResponseWrapped: Decodable {
    let response: NewsFeedResponseModel
}

struct NewsFeedResponseModel: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
    var nextFrom: String?
    
    static let mockObject = NewsFeedResponseModel(
        items: [],
        profiles: [],
        groups: [],
        nextFrom: nil
    )
}

//MARK: - Items
struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachment]?
    
    static func proccess(countableItem: CountableItem?) -> String {
        guard let count = countableItem?.count else { return "" }

        switch count {
        case 0:
            return ""
        case 1...999:
            return String(count)
        case 1000...999_999:
            return String(count/1000) + "К"
        default:
            return String(count/1_000_000) + "М"
        }
    }
}

//MARK: CountableItem
struct CountableItem: Decodable {
    let count: Int
}

//MARK: Attachment
struct Attachment: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]
    
    var photoUrlString: String {
        getPropperSize().url
    }
    
    var width: Int {
        getPropperSize().width
    }
    
    var height: Int {
        getPropperSize().height
    }
    
    func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let sizeY = sizes.first(where: { $0.type == "y" }) {
            return sizeY
        }
        return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

//MARK: Profiles and Groups
protocol ProfileRepresantable {
    var id: Int { get }
    var name: String { get }
    var photoUrlString: String { get }
}

struct Profile: Decodable, ProfileRepresantable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String {
        firstName + " " + lastName
    }
    
    var photoUrlString: String {
        photo100
    }
}

struct Group: Decodable, ProfileRepresantable {
    let id: Int
    let name: String
    let photo100: String
    
    var photoUrlString: String {
        photo100
    }
}
