//
//  NativeCashingImage.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 16.10.2023.
//

import UIKit
import Combine

final class WebImageView: UIImageView {
    
    private var currentURLString: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func set(imageUrlString: String?) {
        currentURLString = imageUrlString
        
        guard let imageUrl = imageUrlString,
              let url = URL(string: imageUrl) else { return }
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cacheResponse.data)
            print("from cache")
            return
        }
        
        print("from internet")
        
        downloadImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                self.image = image
            }
            .store(in: &cancellables)

    }
    
    private func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) in
                return self.handleLoadedImage(data: data, response: response)
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) -> UIImage? {
        guard let responseUrl = response.url else { return nil }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
        
        if responseUrl.absoluteString == currentURLString {
            return UIImage(data: data)
        }
        return nil
    }
}
