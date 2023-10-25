//
//  TitleView.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 18.10.2023.
//

import UIKit
import SnapKit
import Combine
import Kingfisher

final class TitleView: UIView {
    
    private lazy var myAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var searchTextField = SearchTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myAvatarImageView.layer.masksToBounds = true
        myAvatarImageView.layer.cornerRadius = myAvatarImageView.bounds.height/2
        
        
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 10
    }
    
    private func configureSubviews() {
        addSubview(searchTextField)
        addSubview(myAvatarImageView)
        
        myAvatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(4)
            $0.height.equalTo(searchTextField.snp.height)
            $0.width.equalTo(searchTextField.snp.height)
        }
        
        searchTextField.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(myAvatarImageView.snp.leading).offset(-12)
        }
    }
    
    func set(imageUrlString: String) {
        guard let imageUrl = URL(string: imageUrlString) else { return }
        myAvatarImageView.kf.setImage(with: imageUrl)
    }
}
