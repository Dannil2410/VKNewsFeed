//
//  RowLayout.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 18.10.2023.
//

import Foundation
import UIKit

protocol RowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

final class RowLayout: UICollectionViewLayout {
    
    static var numberOfRows = 2
    private var padding: CGFloat = 8
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    weak var delegate: RowLayoutDelegate?
    
    override func prepare() {
        contentWidth = 0
        cache = []
        guard let collectionView = collectionView else { return }
        
        var photos = [CGSize]()
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            guard let photoSize = delegate?.collectionView(collectionView, photoAtIndexPath: indexPath) else { return }
            photos.append(photoSize)
        }
        
        let superViewWidth = collectionView.bounds.width
        
        guard var rowHeight = RowLayout.rowHeightCounter(superViewWidth: superViewWidth, photos: photos) else { return }
        
        rowHeight = rowHeight / CGFloat(RowLayout.numberOfRows)
        
        let photosRatios = photos.map { $0.height/$0.width }
        
        var yOffset = [CGFloat]()
        
        for row in 0..<RowLayout.numberOfRows {
            yOffset.append(CGFloat(row)*rowHeight)
        }
        
        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        
        var row = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoRatio = photosRatios[indexPath.row]
            let width = rowHeight / photoRatio
            let frame = CGRect(
                x: xOffset[row],
                y: yOffset[row],
                width: width,
                height: rowHeight)
            
            let insetFrame = frame.insetBy(dx: padding, dy: padding)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            
            row = row < RowLayout.numberOfRows-1 ? row+1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAtrributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleAtrributes.append(attribute)
            }
        }
        return visibleAtrributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[indexPath.row]
    }
    
    static func rowHeightCounter(superViewWidth: CGFloat, photos: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat
        
        guard let photoWithMinRatio = photos.min(by: { ($0.height/$0.width) < ($1.height/$1.width)}) else { return nil }
        
        let diff = superViewWidth / photoWithMinRatio.width
        rowHeight = photoWithMinRatio.height * diff
        rowHeight = rowHeight * CGFloat(RowLayout.numberOfRows)
        return rowHeight
    }
    
}
