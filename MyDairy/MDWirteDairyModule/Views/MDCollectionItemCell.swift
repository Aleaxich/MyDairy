//
//  MDCollectionItemCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/19.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

class MDCollectionItemCell: UICollectionViewCell {
    var icon:UIImageView
    
    override init(frame: CGRect) {
        icon = UIImageView.init()
        icon.contentMode = .scaleAspectFit
        super.init(frame: frame)
        self.buildSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(_ string:String) {
        icon.image = UIImage.init(named: string)
    }
    
    func buildSubviews() {
        self.contentView.addSubview(icon)
        icon.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
