//
//  NewsFeedCell.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class NewsFeedCell: UITableViewCell {
    static let identifier = "NewsFeedCell"
    static let moreTextButtonNotification = Notification.Name("moreTextButtonNotification")

    //MARK: - UI Private properties
    //MARK: First layer
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    //MARK: Second layer
    private lazy var topView: TopView = {
        let view = TopView()
        return view
    }()
    
    private lazy var postTextView: UITextView = {
        let textView = UITextView()
        textView.font = Constants.postLabelFont
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isSelectable = true
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        return textView
    }()
    
    private lazy var moreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.moreTextButtonTitleFont
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle(Constants.moreTextButtonTitle, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.contentVerticalAlignment = .center
        return button
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var galleryCollectionView: GalleryCollectionView = {
        let galleryCollectionView = GalleryCollectionView()
        return galleryCollectionView
    }()
    
    private lazy var bottomView: BottomView = {
        let view = BottomView()
        return view
    }()
    
    private var indexPath: IndexPath?

    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureCell()
        configureFirstLayer()
        configureSecondLayer()
        configureMoreTextButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureCell()
        configureFirstLayer()
        configureSecondLayer()
        configureMoreTextButton()
    }
    
    //MARK: - Lifecircle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topView.prepareForReuse()
        postImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
    }
    
    //MARK: - Configurations
    
    private func configureCell() {
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func configureFirstLayer() {
        addSubview(cardView)
        
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(Constants.cardViewInsets.left)
            $0.bottom.equalToSuperview().inset(Constants.cardViewInsets.bottom)
        }
    }
    
    private func configureSecondLayer() {
        cardView.addSubview(topView)
        cardView.addSubview(postTextView)
        cardView.addSubview(moreTextButton)
        cardView.addSubview(postImageView)
        cardView.addSubview(galleryCollectionView)
        cardView.addSubview(bottomView)
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(Constants.topViewHeight)
        }
    }
    
    private func configureMoreTextButton() {
        moreTextButton.addTarget(self, action: #selector(moreTextButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func moreTextButtonPressed() {
        guard let indexPath = indexPath else { return }
        NotificationCenter
            .default
            .post(
                name: NewsFeedCell.moreTextButtonNotification,
                object: nil,
                userInfo: ["indexPath": indexPath]
            )
    }
    
    func set(viewModel: NewsFeedCellModel, indexPath: IndexPath) {
        topView.set(viewModel: viewModel.topView)
        
        postTextView.frame = viewModel.sizes.postLabelFrame
        postTextView.text = viewModel.text
        
        moreTextButton.frame = viewModel.sizes.moreTextButtonFrame
        
        if let photoAttachment = viewModel.photoAttachments.first,
           viewModel.photoAttachments.count == 1,
           let photoUrl = URL(string: photoAttachment.photoUrlString) {
            postImageView.frame = viewModel.sizes.photoAttachmentFrame
            postImageView.kf.setImage(with: photoUrl)
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
        } else if viewModel.photoAttachments.count > 1 {
            galleryCollectionView.frame = viewModel.sizes.photoAttachmentFrame
            galleryCollectionView.set(photos: viewModel.photoAttachments)
            postImageView.isHidden = true
            galleryCollectionView.isHidden = false
        } else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
        
        bottomView.frame = viewModel.sizes.bottomViewFrame
        bottomView.set(viewModel: viewModel.bottomView)
        
        self.indexPath = indexPath
        
    }
}
