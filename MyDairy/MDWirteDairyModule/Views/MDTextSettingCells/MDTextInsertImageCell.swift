//
//  MDTextInsertImageCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/5.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then
import RxSwift
import RxCocoa

@objcMembers public class MDTextInsertImageCell : UITableViewCell {
    
    lazy var bag = DisposeBag()
    
    lazy var titleLabel = UILabel().then {
        $0.text = "插入图片"
        $0.textAlignment = .left
    }
    
    lazy var insertImageButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_insert_picture"), for: .normal)

    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        backgroundColor = UIColor(hexString: "#F5F5F5")
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(insertImageButton)
        insertImageButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp_rightMargin).offset(20)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 50, height: 40))
        }
    }
}
