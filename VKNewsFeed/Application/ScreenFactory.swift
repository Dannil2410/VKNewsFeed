//
//  ScreenFactory.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import UIKit

final class ScreenFactory {
    func launchViewController(delegate: LaunchViewControllerDelegate?) -> UIViewController {
        return LaunchViewController(delegate: delegate)
    }
    
    func authViewController(delegate: AuthViewModelDelegate) -> UIViewController {
        let viewModel = AuthViewModel(delegate: delegate)
        return AuthViewController(viewModel: viewModel)
    }
    
    func newsFeedViewController() -> UIViewController {
        let networkService = NetworkService()
        let dataFetcherService = DataFetcherService(networkService: networkService)
        let viewModel = NewsFeedViewModel(dataFetcherService: dataFetcherService)
        return NewsFeedViewController(viewModel: viewModel)
    }
}
