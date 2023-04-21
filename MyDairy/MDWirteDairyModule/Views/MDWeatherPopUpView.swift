//
//  MDWeatherPopUpView.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/19.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation


class MDWeatherPopUpView: MDBasePopover,UICollectionViewDelegate,UICollectionViewDataSource {

    
    // 选择天气
    var iconCollectionView:UICollectionView
    
    
    var iconList = ["icon_weather_sunny","icon_weather_rain","icon_weather_small_rain","icon_weather_cloud","icon_weather_fog","icon_weather_overcast","icon_weather_snow","icon_weather_small_snow","icon_weather_thundershower","icon_weather_wind"]
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumInteritemSpacing = 8;
        flowLayout.minimumLineSpacing = 8
        flowLayout.itemSize = CGSize(width: 70, height: 70)
        flowLayout.scrollDirection = .vertical
        iconCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        iconCollectionView.register(MDCollectionItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(MDCollectionItemCell.self))
        super.init()
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        self.buildSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildSubviews() {
        iconCollectionView.backgroundColor = .gray
        
        self.addSubview(iconCollectionView)
        iconCollectionView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.size.equalTo(CGSize(width: SCREEN_WIDTH_SWIFT, height: 200))
            maker.centerX.equalToSuperview()
        }
    }
    
    // MARK: delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           self.iconList.count
       }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MDCollectionItemCell.self), for: indexPath) as! MDCollectionItemCell
        cell.loadData(iconList[indexPath.item])
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedAction = selectedAction {
            selectedAction(iconList[indexPath.item])
        }
        dismiss()
    }
}


