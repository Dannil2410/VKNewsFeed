//
//  NetworkService.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine

protocol Networking {
    func request<T: Decodable>(for url: URL) -> AnyPublisher<T, NetworkError>
}

struct NetworkService: Networking {
    
    private let session = URLSession.shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func request<T>(for url: URL) -> AnyPublisher<T, NetworkError> where T : Decodable {
        return session.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse {
                    guard (200...299).contains(response.statusCode) else {
                        throw NetworkError.invalidResponseCode(response.statusCode)
                    }
                }
                return data
            }
//            .tryMap { data in
//                let json = try JSONSerialization.jsonObject(with: data)
//                print(json)
//                return data
//            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> NetworkError in
                if let _ = error as? DecodingError {
                    return NetworkError.decodingError
                }
                return error as! NetworkError
            }
            .eraseToAnyPublisher()
    }
}
