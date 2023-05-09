//
//  MDPhotoWallViewController.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/16.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then

struct imageData {
    var imageList:[NSData]
    var date:String
    var orderNum:Int32
}

class MDPhotoWallViewController : UIViewController {
    /// 数据源
    lazy var imageDataList = [imageData]()
    
    lazy var coreDataManager = MDCoreDataManager.shareInstance
    
    lazy var collectionView = {
        
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: (SCREEN_WIDTH_SWIFT - 20 ) / 3, height: (SCREEN_WIDTH_SWIFT - 20 ) / 3)
            $0.minimumLineSpacing = 5
            $0.minimumInteritemSpacing = 5
            $0.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 5, right: 5)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MDPhotoWallCell.self, forCellWithReuseIdentifier: NSStringFromClass(MDPhotoWallCell.self))
        collectionView.register(MDPhotoWallHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(MDPhotoWallHeaderView.self))
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setupSubviews()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func loadData() {
        let models = coreDataManager.getCoreData()
        models?.forEach({
            guard let imageList = $0.imageList else { return }
            if imageList.count != 0 {
                let dateFormer = DateFormatter()
                dateFormer.dateFormat = "yyyy.MM.dd"
                imageDataList.append(imageData(imageList: imageList as! [NSData], date: dateFormer.string(from: $0.createdDate!), orderNum: $0.orderNum))
            }
        })
        collectionView.reloadData()
    }
}

extension MDPhotoWallViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        imageDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageDataList[section].imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MDPhotoWallCell.self), for: indexPath) as! MDPhotoWallCell
        let list = imageDataList[indexPath.section].imageList
        cell.loadData(imageData: list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(MDPhotoWallHeaderView.self), for: indexPath) as! MDPhotoWallHeaderView
            headerView.loadData(data:(imageDataList[indexPath.section]).date)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: SCREEN_WIDTH_SWIFT, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = MDPhotoWallDetailView.init(imageList: imageDataList[indexPath.section].imageList,selectedIndexPath: indexPath)
        view.imageListChanged = {[weak self] imageList in
            let data = self?.imageDataList[indexPath.section]
            let orderNum = data?.orderNum
            let model = self?.coreDataManager.getDataWithOrderNum(orderNum)
            var mutableArray = [NSData]()
            imageList?.forEach {
                mutableArray.append($0)
            }
            model?.imageList = mutableArray as? NSMutableArray
            self?.coreDataManager.changeDataWithModel(model: model!)
        }
        view.show()
        
    }
}
