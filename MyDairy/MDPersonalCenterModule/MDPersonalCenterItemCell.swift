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
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .red
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selected))
        contentView.addGestureRecognizer(gesture)
    }
    
    @objc func selected() {
        guard let action = selectedAction else { return }
        action()
    }
    
}


