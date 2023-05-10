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

    /// 删除了全部的图片
    var deleteAllPictures:(() -> ())?
    
    /// 删除图片
    var deletePicture:((_ index:Int) -> ())?
    
    /// 是否显示删除按钮
    var showHiddenButton = false
    
    lazy var collectionView:UICollectionView = {
        let spacing:CGFloat = 8
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.itemSize = CGSize(width: SCREEN_WIDTH_SWIFT - spacing * 2, height: 300)
            $0.minimumInteritemSpacing = spacing
            $0.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MDPicturesViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(MDPicturesViewCell.self))
        return collectionView
    }()
    
    public lazy var imageDataList:[NSData] = [NSData]()
    
    
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
        cell.startAnimation()

        cell.deleteAction = {[weak self] in
            collectionView.performBatchUpdates({
                self!.imageDataList.remove(at: indexPath.item)
                collectionView.deleteItems(at: [indexPath])
                guard let action = self!.deletePicture else { return }
                action(indexPath.item)
            }, completion: {_ in
                if self!.imageDataList.count == 0 {
                    guard let action = self!.deleteAllPictures else { return }
                    action()
                } else {
                    collectionView.reloadData()
                    self!.layoutIfNeeded()
                    let cell = collectionView.visibleCells.first as! MDPicturesViewCell
                    cell.startAnimation()
                }
            })
        }
        
        cell.dismissDeleteButton = {[weak self] in
            self!.showHiddenButton = false
            collectionView.reloadData()
        }
        
        cell.showDeleteButton = {[weak self] in
            self!.showHiddenButton = true
            collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let mdCell = cell as! MDPicturesViewCell
        if showHiddenButton {
            mdCell.startAnimation()
        } else {
            mdCell.stopAnimation()
        }
    }
    
  
    
  
}
