//
//  Session.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import Foundation

final class Session {
    
    static let shared = Session()
    
    private init() {}
    
    var accessToken = ""
    var userId = ""
}
