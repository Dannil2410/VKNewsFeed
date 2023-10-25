//
//  String+Extensions.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 16.10.2023.
//

import UIKit

extension String {
    func height(
        font: UIFont,
        width: CGFloat = .greatestFiniteMagnitude,
        height: CGFloat = .greatestFiniteMagnitude
    ) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(
            with: textSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        
        return ceil(size.height) 
    }
    
    func width(font: UIFont,
               width: CGFloat = .greatestFiniteMagnitude,
               height: CGFloat = .greatestFiniteMagnitude
    ) -> CGFloat {
        let textSize = CGSize(width: width, height: height)
        
        let size = self.boundingRect(
            with: textSize,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        
        return ceil(size.width)
    }
}
