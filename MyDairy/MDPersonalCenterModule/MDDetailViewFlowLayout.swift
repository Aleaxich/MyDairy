//
//  MDDetailViewFlowLayout.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/18.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

class MDDetailViewFlowLayout:UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .horizontal
        itemSize = CGSize(width: SCREEN_WIDTH_SWIFT, height: 500)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var adjustment:CGFloat = 9999999
        ///  视图中心
        let centerx = proposedContentOffset.x + collectionView!.bounds.width / 2.0
        let rect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        /// 获得 rect 内所有 view
        let arr = super.layoutAttributesForElements(in: rect)
        arr?.forEach({
            let itemCenter = $0.center.x
            if abs(itemCenter - centerx) < abs(adjustment) {
                adjustment = itemCenter - centerx
            }
        })
        return CGPoint(x: proposedContentOffset.x + adjustment , y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}
