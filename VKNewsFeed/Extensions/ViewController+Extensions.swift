//
//  ViewController+Extensions.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import UIKit

extension UIViewController: Routable {
    func showViewController(_ controller: UIViewController, animated: Bool) {
        if let navVC = self as? UINavigationController {
            navVC.pushViewController(controller, animated: animated)
        } else {
            present(controller, animated: animated)
        }
    }
    
    func presentViewController(_ controller: UIViewController, animated: Bool) {
        present(controller, animated: animated)
    }
}
