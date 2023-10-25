//
//  NetworkError.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case genericError(String)
    case invalidResponseCode(Int)
    
    var errorMessageString: String {
        switch self {
        case .invalidURL:
            return "Invalid URL encountered. Can't proceed with the request"
        case .decodingError:
            return "Encountered an error while decoding incoming server response. The data couldn’t be read because it isn’t in the correct format."
        case .genericError(let message):
            return message
        case .invalidResponseCode(let responseCode):
            return "Invalid response code encountered from the server. Expected 200, received \(responseCode)"
        }
    }
}
