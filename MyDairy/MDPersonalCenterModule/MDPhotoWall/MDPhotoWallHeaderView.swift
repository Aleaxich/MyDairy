//
//  MDPhotoWallHeaderView.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/17.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then

class MDPhotoWallHeaderView : UICollectionReusableView {
    
    lazy var dateLabel = UILabel().then {
        $0.textColor = UIColor(hexString: "D3D3D3")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(data:String) {
        dateLabel.text = data
    }
    
    func setupSubviews() {
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
