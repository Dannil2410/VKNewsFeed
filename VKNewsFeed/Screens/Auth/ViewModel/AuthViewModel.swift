//
//  AuthViewModel.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import Foundation
import Combine
import WebKit

final class AuthViewModel {
    
    private weak var delegate: AuthViewModelDelegate?
    
    @Published var dismissAuthVC = false
    
    init(delegate: AuthViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func createRequest() -> URLRequest {
        guard let url = VKAuthAPI.vkAuthURL() else { fatalError() }
        return URLRequest(url: url)
    }
    
    func processAccessToken(response: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = response.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else { decisionHandler(.allow); return}
        
        let params = getResponseParams(fragment)
        
        guard let token = params["access_token"],
              let userIdString = params["user_id"] else {
            decisionHandler(.allow)
            return
        }

        Session.shared.accessToken = token
        Session.shared.userId = userIdString
        
        decisionHandler(.cancel)
        dismissAuthVC = true
    }
    
    func moveToNewsFeedViewController() {
        delegate?.moveToNewsFeedViewController()
    }
    
    private func getResponseParams(_ fragment: String) -> [String: String] {
        fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String: String]()) {result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
    }
}

extension AuthViewModel {
    struct VKAuthAPI {
        private static let scheme = "https"
        private static let host = "oauth.vk.com"
        private static let path = "/authorize"
        private static let clientId = "51773948"
        private static let scope = 2+4+8192+262144
        
        static func vkAuthURL() -> URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            components.queryItems = [
                URLQueryItem(name: "client_id", value: clientId),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: String(scope)),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.154")
            ]
            return components.url
        }
    }
}
