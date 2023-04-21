//
//  MDPhotoWallCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/17.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then

class MDPhotoWallCell : UICollectionViewCell {
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(imageData:NSData) {
        imageView.image = UIImage(data: imageData as Data)
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
