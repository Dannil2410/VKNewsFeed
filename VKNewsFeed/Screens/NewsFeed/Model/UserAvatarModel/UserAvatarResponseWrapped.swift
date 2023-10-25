//
//  UserAvatarResponseWrapped.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 18.10.2023.
//

import Foundation

struct UserAvatarResponseWrapped: Decodable {
    let response: PhotoItem
}

struct PhotoItem: Decodable {
    let items: [Photo]
}
