//
//  UserAvatarModel.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 18.10.2023.
//

import Foundation

protocol UserAvatarModelProtocol {
    var avatarUrlString: String? { get }
}

struct UserAvatarModel: UserAvatarModelProtocol {
    var avatarUrlString: String?
}
