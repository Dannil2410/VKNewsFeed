//
//  GalleryCollectionView.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 18.10.2023.
//

import UIKit

final class GalleryCollectionView: UICollectionView {
    
    private var photos = [NewsFeedCellPhotoAttachmentModel]()
    
    init() {
        let rowLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLayout)
        dataSource = self
        rowLayout.delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photos: [NewsFeedCellPhotoAttachmentModel]) {
        self.photos = photos
        contentOffset = .zero
        reloadData()
    }
}

extension GalleryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { fatalError() }
        
        let photo = photos[indexPath.row]
        cell.set(photo: photo.photoUrlString)
        
        return cell
    }
}

extension GalleryCollectionView: RowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.row]
        return CGSize(width: photo.width, height: photo.height)
    }
}
