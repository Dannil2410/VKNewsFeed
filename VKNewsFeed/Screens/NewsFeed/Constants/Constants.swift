//
//  Constants.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 16.10.2023.
//

import Foundation
import UIKit

struct Constants {
    
    //MARK: - subviews of CardView
    static let cardViewInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    
    static let topViewHeight: CGFloat = 60
    
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    
    static let postLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    static let bottomViewHeight: CGFloat = 50
    
    //MARK: - UserInteractionView
    static let userInterLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    
    static let userInterViewVerticalInset: CGFloat = 7
    
    static let userInterViewHeight: CGFloat = Constants.bottomViewHeight - Constants.userInterViewVerticalInset*2
    
    static let userInteractionImageViewLeadingInset: CGFloat = 9
    
    static let countLabelTrailingInset: CGFloat = 9
    
    static let userInteractionImageViewMultiplier: CGFloat = 2/3
    
    //MARK: - MoreTextButton
    static let moreTextButtonTitle = "Показать полностью..."
    
    static let moreTextButtonTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 6
    
    static let moreTextButtonSize = CGSize(width: 200, height: 35)
}
