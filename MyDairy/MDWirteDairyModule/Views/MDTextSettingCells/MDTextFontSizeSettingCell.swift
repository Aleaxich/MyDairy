//
//  MDTextFontSizeSettingCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/2.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MDTextFontSizeSettingCell: UITableViewCell {
    
    lazy var titleLabel = UILabel().then {
        $0.text = "大小"
        $0.textAlignment = .left
    }
    
    lazy var button1 = MDTextSettingButton().then{
        $0.setTitle("小", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.sizeInfo = 16
        $0.showBoarder = true
    }
    
    lazy var button2 = MDTextSettingButton().then{
        $0.setTitle("较小", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.sizeInfo = 18
        $0.showBoarder = true
    }
    
    lazy var button3 = MDTextSettingButton().then{
        $0.setTitle("中等", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.sizeInfo = 20
        $0.showBoarder = true
    }
    
    lazy var button4 = MDTextSettingButton().then{
        $0.setTitle("较大", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.sizeInfo = 22
        $0.showBoarder = true
    }
    
    lazy var button5 = MDTextSettingButton().then{
        $0.setTitle("大", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.sizeInfo = 24
        $0.showBoarder = true
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(size:CGFloat) {
        let buttons = [button1,button2,button3,button4,button5]
        for button in buttons {
            button.isSelected = button.sizeInfo == size
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
              stackView.addArrangedSubview(button3)
              stackView.addArrangedSubview(button4)
              stackView.addArrangedSubview(button5)


        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp_rightMargin).offset(10)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 300, height: 50))
        }
    }
    
}
