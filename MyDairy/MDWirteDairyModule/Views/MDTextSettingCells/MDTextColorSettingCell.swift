//
//  MDTextColorSettingCellTableViewCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/2.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import UIKit

public class MDTextColorSettingCell: UITableViewCell {

    lazy var titleLabel = UILabel().then {
        $0.text = "颜色"
        $0.textAlignment = .left
    }
    
    lazy var button1 = MDTextSettingButton().then{
        $0.backgroundColor = UIColor(hexString: "#000000")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.colorInfo = "#000000"
        $0.setImage(UIImage(named: "icon_item_selected"), for: .selected)

    }
    
    lazy var button2 = MDTextSettingButton().then{
        $0.backgroundColor = UIColor(hexString: "#696969")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.colorInfo = "#696969"
        $0.setImage(UIImage(named: "icon_item_selected"), for: .selected)

    }
    
    lazy var button3 = MDTextSettingButton().then{
        $0.backgroundColor = UIColor(hexString: "#FF6347")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.colorInfo = "#FF6347"
        $0.setImage(UIImage(named: "icon_item_selected"), for: .selected)


    }
    
    lazy var button4 = MDTextSettingButton().then{
        $0.backgroundColor = UIColor(hexString: "#D2691E")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.colorInfo = "#D2691E"
        $0.setImage(UIImage(named: "icon_item_selected"), for: .selected)


    }
    
    lazy var button5 = MDTextSettingButton().then{
        $0.backgroundColor = UIColor(hexString: "#D2B48C")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.colorInfo = "#D2B48C"
        $0.setImage(UIImage(named: "icon_item_selected"), for: .selected)

    }
    
    lazy var crossLine = UIView().then {
        $0.backgroundColor = .gray
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(colorHexString:String) {
        let buttons = [button1,button2,button3,button4,button5]
        for button in buttons {
            button.isSelected = button.colorInfo == colorHexString
        }
    }
    
    func setupSubviews() {
        backgroundColor = UIColor(hexString: "#F5F5F5")
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
            maker.size.equalTo(CGSize(width: 300, height: 35))
        }
        
        contentView.addSubview(crossLine)
        crossLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.centerX.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
    }
}
