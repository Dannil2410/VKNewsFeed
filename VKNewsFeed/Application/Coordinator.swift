//
//  File.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import UIKit

final class Coordinator {
    
    private let screenFactory: ScreenFactory
    var navigationController: Routable?
    
    init(screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
    }
}

extension Coordinator: LaunchViewControllerDelegate {
    func moveToAuthViewController() {
        let authViewController = screenFactory.authViewController(delegate: self)
        navigationController?.presentViewController(authViewController, animated: true)
    }
}

extension Coordinator: AuthViewModelDelegate {
    func moveToNewsFeedViewController() {
        let newsFeedViewController = screenFactory.newsFeedViewController()
        navigationController?.showViewController(newsFeedViewController, animated: true)
    }
}
