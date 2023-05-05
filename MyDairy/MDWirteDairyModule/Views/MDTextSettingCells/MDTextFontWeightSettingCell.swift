//
//  MDTextFontWeightSettingCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/5.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

class MDTextFontWeightSettingCell:UITableViewCell {
    
    lazy var titleLabel = UILabel().then {
        $0.text = "粗细"
        $0.textAlignment = .left
    }
    
    
    lazy var button1 = MDTextSettingButton().then{
        $0.setTitle("常规", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.weightInfo = ".regular"
        $0.showBoarder = true
    }
    
    lazy var button2 = MDTextSettingButton().then{
        $0.setTitle("加粗", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.weightInfo = "bold"
        $0.showBoarder = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(weight:String) {
        let buttons = [button1,button2]
        for button in buttons {
            button.isSelected = button.weightInfo == weight
        }
    }
    
    func setupSubviews() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.centerY.equalToSuperview()
        }
        
        let stackView = UIStackView.init()
              stackView.axis = .horizontal
              stackView.alignment = .fill
              stackView.spacing = 10
              stackView.distribution = .fillEqually
              stackView.addArrangedSubview(button1)
              stackView.addArrangedSubview(button2)
            


        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp_rightMargin).offset(10)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 300, height: 50))
        }
    }
}
