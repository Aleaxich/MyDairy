//
//  MDPersonalCenterItemCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/4/16.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then

class MDPersonalCenterItemCell : UITableViewCell {
    
   lazy var titleLabel = UILabel().then {
       $0.textColor = .gray
       $0.textAlignment = .center
    }
    
    lazy var icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var crossLine = UIView().then {
        $0.backgroundColor = .gray
    }
    
    var selectedAction:(() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(model:MDPersonalCenterSettingItemModel) {
        titleLabel.text = model.title
        selectedAction = model.selectedAction
        icon.image = UIImage(named: model.image)
    }
    
    private func setupSubviews() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.right.equalTo(titleLabel.snp_leftMargin).offset(-12)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(crossLine)
        crossLine.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 0.5))
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selected))
        contentView.addGestureRecognizer(gesture)
    }
    
    @objc func selected() {
        guard let action = selectedAction else { return }
        action()
    }
    
}


