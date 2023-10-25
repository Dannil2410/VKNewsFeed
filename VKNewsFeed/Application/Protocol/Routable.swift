//
//  Routable.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import UIKit

protocol Routable {
    func showViewController(_ controller: UIViewController, animated: Bool)
    func presentViewController(_ controller: UIViewController, animated: Bool)
}
