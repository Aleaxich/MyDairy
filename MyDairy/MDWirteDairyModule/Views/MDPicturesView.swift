//
//  MDPicturesView.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/12.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import UIKit
import Then

class MDPicturesView:UIView, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.itemSize = CGSize(width: SCREEN_WIDTH_SWIFT - 50, height: 300)
            $0.minimumInteritemSpacing = 25
            $0.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MDPicturesViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(MDPicturesViewCell.self))
        return collectionView
    }()
    
    lazy var imageDataList:[NSData] = [NSData]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadData(imageDataList:[NSData]){
        self.imageDataList = imageDataList
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MDPicturesViewCell.self), for: indexPath) as! MDPicturesViewCell
        cell.loadData(imageDataList[indexPath.item])
        cell.deleteAction = {[weak self] in
            collectionView.performBatchUpdates({
                self?.imageDataList.remove(at: indexPath.item)
                       collectionView.deleteItems(at: [indexPath])
            }, completion: {_ in
                collectionView.reloadData()
            })
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageDataList.count
    }
    
  
}
