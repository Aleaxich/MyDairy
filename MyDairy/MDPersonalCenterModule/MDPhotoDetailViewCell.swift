//
//  MDPhotoDetailViewCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/17.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then

class MDPhotoDetailViewCell: UICollectionViewCell {
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(_ image:UIImage) {
            imageView.image = image
    }
    
    func setupSubviews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
