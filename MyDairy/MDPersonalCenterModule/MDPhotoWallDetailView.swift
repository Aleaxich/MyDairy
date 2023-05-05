//
//  MDPhotoWallDetailView.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/17.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then
import RxSwift
import RxCocoa
import UIKit

class MDPhotoWallDetailView : MDBasePopover {
    /// 数据源
    lazy var imageDataList = [NSData]()
    
    lazy var bag = DisposeBag()
    /// 用户删除图片
    var imageListChanged:(([NSData]?) -> ())?
    
    /// 删除按钮
    lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_delete_image"), for: .normal)
        $0.rx
            .tap
            .subscribe { [weak self] event in
                var item = self?.collectionView.indexPathsForVisibleItems.first
                guard let realItem = item else {return}
                self?.collectionView.performBatchUpdates({
                    self?.imageDataList.remove(at: realItem.item)
                    self?.collectionView.deleteItems(at: [realItem])
//                    guard let changedAction = self?.imageListChanged else { return }
//                    changedAction(self?.imageDataList)
                }, completion: {_ in
                    self?.collectionView.reloadData()
                })
            }.disposed(by: bag)
    }
    
    lazy var saveButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_save_image"), for: .normal)
        $0.rx
            .tap
            .subscribe {[weak self] event in
                let cell = self?.collectionView.visibleCells.first as! MDPhotoDetailViewCell
                UIImageWriteToSavedPhotosAlbum(cell.imageView.image!, self, #selector(self?.saveError), nil)
            }.disposed(by: bag)
    }
    
    /// 当前选中
    var currentIndexPath:IndexPath
    
    /// 序号
    lazy var orderLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    lazy var collectionView =  {

        let layout = MDDetailViewFlowLayout.init()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MDPhotoDetailViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(MDPhotoDetailViewCell.self))
        return collectionView
    }()
    
    init(imageList:[NSData],selectedIndexPath:IndexPath) {
        currentIndexPath = NSIndexPath(item: selectedIndexPath.item, section: 0) as IndexPath
        super.init()
//        imageDataList = imageList
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        backgroundColor = .black
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: SCREEN_WIDTH_SWIFT, height: 500))
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.bottom.equalToSuperview().offset(-200)
            make.right.equalToSuperview().offset(-100)
        }
        
        self.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.bottom.equalToSuperview().offset(-200)
            make.left.equalTo(deleteButton.snp_rightMargin).offset(30)
        }
        
        self.addSubview(orderLabel)
        orderLabel.text = "\(currentIndexPath.item + 1) / \(imageDataList.count)"
        orderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        
        collectionView.reloadData()
        /// reloadData 异步
        self.layoutIfNeeded()
        collectionView.scrollToItem(at: currentIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    

  @objc func saveError(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {

        if didFinishSavingWithError != nil {
            SVProgressHUD.showError(withStatus: "保存失败")
            SVProgressHUD.dismiss(withDelay: 0.5)
            return
        }
        SVProgressHUD.showSuccess(withStatus: "保存成功")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
}

extension MDPhotoWallDetailView:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MDPhotoDetailViewCell.self), for: indexPath) as! MDPhotoDetailViewCell
        cell.loadImage(UIImage(data: imageDataList[indexPath.item] as Data)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageDataList.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        orderLabel.text = "\(String(describing: collectionView.indexPathsForVisibleItems.first!.item + 1)) / \(imageDataList.count)"
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            orderLabel.text = "\(String(describing: collectionView.indexPathsForVisibleItems.first!.item + 1)) / \(imageDataList.count)"
        }
    }
}
