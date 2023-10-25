//
//  TopView.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class TopView: UIView {
    
    //MARK: - Private properties

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAvatarImageView()
        configureAuthorNewsFeedLabel()
        configureDateLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAvatarImageView()
        configureAuthorNewsFeedLabel()
        configureDateLabel()
    }
    
    //MARK: Lifecircle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height/2
    }
    
    //MARK: - Configurations
    
    private func configureAvatarImageView() {
        addSubview(avatarImageView)
        
        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(5)
            $0.top.equalToSuperview().inset(5)
            $0.size.equalTo(50)
        }
    }
    
    private func configureAuthorNewsFeedLabel() {
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatarImageView).offset(-10)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func configureDateLabel() {
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatarImageView).offset(5)
            $0.directionalHorizontalEdges.equalTo(nameLabel)
        }
    }
    
    func set(viewModel: TopViewNewsFeedCellModel) {
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date

        guard let avatarUrl = URL(string: viewModel.avatarUrlString) else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle")
            return
        }

        avatarImageView.kf.setImage(with: avatarUrl)
    }
    
    func prepareForReuse() {
        avatarImageView.image = nil
    }
}
