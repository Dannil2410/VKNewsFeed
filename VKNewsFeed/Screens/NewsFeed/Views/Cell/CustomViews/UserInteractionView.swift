//
//  UserInteractionView.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 15.10.2023.
//

import UIKit
import SnapKit

class UserInteractionView: UIView {

    private lazy var userInteractionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.userInterLabelFont
        label.textColor = .systemGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUserInteractionImageView()
        configureCountLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUserInteractionImageView()
        configureCountLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height/2
        layer.backgroundColor = UIColor.systemGray6.cgColor
    }
    
    private func configureUserInteractionImageView() {
        addSubview(userInteractionImageView)
        
        userInteractionImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(self.snp.height)
                .multipliedBy(Constants.userInteractionImageViewMultiplier)
            $0.leading.equalToSuperview()
                .inset(Constants.userInteractionImageViewLeadingInset)
        }
    }
    
    private func configureCountLabel() {
        addSubview(countLabel)
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(userInteractionImageView)
            $0.leading.equalTo(userInteractionImageView.snp.trailing)
            $0.trailing.equalToSuperview()
                .inset(Constants.countLabelTrailingInset)
        }
    }
    
    func setupImageView(imageName: String) {
        guard let image = UIImage(systemName: imageName)?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal) else { return }
        
        userInteractionImageView.image = image
    }
    
    func set(count: String) {
        countLabel.text = count
    }
}
