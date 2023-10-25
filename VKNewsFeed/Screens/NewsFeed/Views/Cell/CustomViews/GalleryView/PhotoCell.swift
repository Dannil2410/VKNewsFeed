//
//  PhotoCell.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 18.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurePhotoImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
    
    private func configurePhotoImageView() {
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func set(photo: String) {
        if let photoUrl = URL(string: photo) {
            photoImageView.kf.setImage(with: photoUrl)
        }
    }
}
