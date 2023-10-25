//
//  SearchTextField.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 18.10.2023.
//

import UIKit

class SearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray6
        placeholder = "Поиск"
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
        borderStyle = .none
        clearButtonMode = .always
        
        let image = UIImage(systemName: "magnifyingglass")?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        leftView = UIImageView(image: image)
        leftView?.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 36, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 36, dy: 0)
    }
}
