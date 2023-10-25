//
//  DataFetcherService.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine

protocol DataFetcher {
    func getNewsFeed(nextFrom: String?) -> AnyPublisher<NewsFeedResponseWrapped, NetworkError>
    func getUserAvatar() -> AnyPublisher<UserAvatarResponseWrapped, NetworkError>
}

final class DataFetcherService: DataFetcher {
    
    private let networkService: Networking
    
    init(networkService: Networking) {
        self.networkService = networkService
    }
    
    func getNewsFeed(nextFrom: String? = nil) -> AnyPublisher<NewsFeedResponseWrapped, NetworkError> {
        guard let url = VkAPI.getNewsFeedURL(nextFrom: nextFrom) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        print(url)
        return networkService.request(for: url)
    }
    
    func getUserAvatar() -> AnyPublisher<UserAvatarResponseWrapped, NetworkError> {
        guard let url = VkAPI.getUserAvatarUrl() else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        print(url)
        return networkService.request(for: url)
    }
}

extension DataFetcherService {
    struct VkAPI {
        private static let scheme = "https"
        private static let host = "api.vk.com"
        private static let newsFeedGetPath = "/method/newsfeed.get"
        private static let userPhotosGetPath = "/method/photos.get"
        private static let version = "5.154"
        private static let accessToken = Session.shared.accessToken
        private static let userId = Session.shared.userId
        
        static func getNewsFeedURL(nextFrom: String?) -> URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = newsFeedGetPath
            
            var queryItems = [
                URLQueryItem(name: "filters", value: "post,photo"),
                URLQueryItem(name: "access_token", value: accessToken),
                URLQueryItem(name: "v", value: "5.154")
            ]
            
            if let nextFrom = nextFrom {
                queryItems.append(URLQueryItem(name: "start_from", value: nextFrom))
            }
            
            components.queryItems = queryItems
            return components.url
        }
        
        static func getUserAvatarUrl() -> URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = userPhotosGetPath
            components.queryItems = [
                URLQueryItem(name: "access_token", value: accessToken),
                URLQueryItem(name: "owner_id", value: userId),
                URLQueryItem(name: "album_id", value: "profile"),
                URLQueryItem(name: "v", value: "5.131")
            ]
            return components.url
        }
    }
}
