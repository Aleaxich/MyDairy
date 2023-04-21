//
//  MDWriteNoteSettingCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/20.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum MDWriteNoteSettingItemType {
    // 对齐
    case MDWriteNoteSettingItemAlign
    // 大小
    case MDWriteNoteSettingItemFontSize
    // 粗细
    case MDWriteNoteSettingItemFontWeight
    // 颜色
    case MDWriteNoteSettingItemFontColor
    // 选择封面
    case MDWriteNoteSettingItemInsertPic
}



class MDSettingItemButton: UIButton {
    lazy var bag:DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setTitleColor(UIColor(hexString: "8a8a8a"), for: .normal)
        self.setTitleColor(UIColor(hexString: "d81e06"), for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // 快捷设置标题及点击事件
    /// - Parameters: title 标题
    /// - Parameters: backGroundColor 背景色
    /// - Parameters: userInfo
    /// - Parameters: NotificationName 通知名称
    func setButtonInfo(normalImage:String?,selectedImage:String?,title:String?,backGroundColor:String?,userInfo:[AnyHashable : Any],lastSelected: RecordLastSelected, settingNotificationName:String) {
        
        assert(normalImage != nil || title != nil || backGroundColor != nil,"选中团颜色和标题不能同时为空")
        
        if normalImage != nil && selectedImage != nil {
            self.setImage(UIImage(named: normalImage!), for: .normal)
            self.setImage(UIImage(named: selectedImage!), for: .selected)
        } else if backGroundColor != nil {
            self.backgroundColor = UIColor(hexString: backGroundColor!)
        } else {
            self.setTitle(title, for: .normal)
        }
        
        self.rx
            .tap
            .subscribe { event in
            self.changeToSelected(lastSelectedButton: lastSelected)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: settingNotificationName), object: nil, userInfo: userInfo)
        }.disposed(by: bag)
        
//        self.add_Action { (sender) in
//            self.changeToSelected(lastSelectedButton: lastSelected)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: settingNotificationName), object: nil, userInfo: userInfo)
//                }
       }
    
    
    func changeToSelected(lastSelectedButton: RecordLastSelected) {
        if lastSelectedButton.lastSelectedButton === self {
            return
        } else {
        lastSelectedButton.lastSelectedButton.isSelected = !lastSelectedButton.lastSelectedButton.isSelected
        lastSelectedButton.lastSelectedButton = self
        self.isSelected = !self.isSelected
        }
    }
    
}


class RecordLastSelected {
    var lastSelectedButton:MDSettingItemButton
    init() {
        lastSelectedButton = MDSettingItemButton.init()
    }
}



class MDWriteNoteSettingCell: UITableViewCell {
    var titleLabel: UILabel
    lazy var firstButton = MDSettingItemButton.init()
    lazy var secondButton = MDSettingItemButton.init()
    lazy var thirdButton = MDSettingItemButton.init()
    lazy var fourthButton = MDSettingItemButton.init()
    lazy var fifthButton = MDSettingItemButton.init()
    // 上次最终选择的按钮
    var lastSelected = RecordLastSelected.init()
    
    
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel.init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadDataWithType(type:MDWriteNoteSettingItemType) {
        buildSubviewsWithType(type: type)
    }
    
    // 根据输入的
    private func buildSubviewsWithType(type:MDWriteNoteSettingItemType) {
        switch type {
        case .MDWriteNoteSettingItemAlign:
            setupAligView()
        break
        case .MDWriteNoteSettingItemFontWeight:
            setupWeightView()
        break
        case .MDWriteNoteSettingItemFontSize:
            setupSizeView()
        break
        case .MDWriteNoteSettingItemFontColor:
            setupColorView()
        break
        case .MDWriteNoteSettingItemInsertPic:
            setupInsertPicView()
        break
        default:
           ()
        }
    }
    
    func setupBaseView() {
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
              stackView.addArrangedSubview(firstButton)
              stackView.addArrangedSubview(secondButton)
              stackView.addArrangedSubview(thirdButton)
              stackView.addArrangedSubview(fourthButton)
              stackView.addArrangedSubview(fifthButton)
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp_rightMargin).offset(10)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 300, height: 50))
        }
    }
    
    
    
    // 未选中 8a8a8a 选中 d81e06
}

extension MDWriteNoteSettingCell{
    
    func setupAligView() {
        self.titleLabel.text = "对齐"
        self.firstButton.setButtonInfo(normalImage: "icon_setting_left", selectedImage: "icon_setting_left_selected", title: nil, backGroundColor: nil, userInfo: ["userInfo":NSTextAlignment.left], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.alignmentSettingChanged)
        
        self.secondButton.setButtonInfo(normalImage: "icon_setting_center", selectedImage: "icon_setting_center_selected", title: nil, backGroundColor: nil, userInfo: ["userInfo":NSTextAlignment.center], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.alignmentSettingChanged)
        
        self.thirdButton.setButtonInfo(normalImage: "icon_setting_right", selectedImage: "icon_setting_right_selected", title: nil, backGroundColor: nil, userInfo: ["userInfo":NSTextAlignment.right], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.alignmentSettingChanged)
        
    }
}

extension MDWriteNoteSettingCell{
    
    func setupWeightView() {
        self.titleLabel.text = "粗细"
        
        self.firstButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: "常体", backGroundColor: nil, userInfo: ["userInfo":UIFont.Weight.regular], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.fontBoldSettingChanged)
        
        self.secondButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: "粗体", backGroundColor: nil, userInfo: ["userInfo":UIFont.Weight.bold], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.fontBoldSettingChanged)

    }
}

extension MDWriteNoteSettingCell{
    func setupSizeView() {
        self.titleLabel.text = "大小"
        
        self.firstButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: "小", backGroundColor: nil, userInfo: ["userInfo":14], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.fontSizeSettingChanged)
        
        self.secondButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: "较小", backGroundColor: nil, userInfo: ["userInfo":18], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.fontSizeSettingChanged)
        
        self.thirdButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: "中等", backGroundColor: nil, userInfo: ["userInfo":22], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.fontSizeSettingChanged)
        
        self.fourthButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: "较大", backGroundColor: nil, userInfo: ["userInfo":26], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.fontSizeSettingChanged)
        
        self.fifthButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: "大", backGroundColor: nil, userInfo: ["userInfo":30], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.fontSizeSettingChanged)
    }

}

extension MDWriteNoteSettingCell {
    func setupColorView() {
        self.titleLabel.text = "颜色"
        
        self.firstButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: nil, backGroundColor:"#000000", userInfo: ["userInfo":"#000000"], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.colorSettingChanged)
        
        self.secondButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: nil, backGroundColor:"#696969", userInfo: ["userInfo":"#696969"], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.colorSettingChanged)
        
        self.thirdButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: nil, backGroundColor:"#FF6347", userInfo: ["userInfo":"#FF6347"], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.colorSettingChanged)
        
        self.fourthButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: nil, backGroundColor:"#D2691E", userInfo: ["userInfo":"#D2691E"], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.colorSettingChanged)
        
        self.fifthButton.setButtonInfo(normalImage: nil, selectedImage: nil, title: nil, backGroundColor:"#D2B48C", userInfo: ["userInfo":"#D2B48C"], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.colorSettingChanged)
        
        }
    }

extension MDWriteNoteSettingCell {
    func setupInsertPicView() {
        self.titleLabel.text = "插入今日封面"
        self.firstButton.setButtonInfo(normalImage: "icon_insert_pic", selectedImage: "icon_insert_pic", title: nil, backGroundColor:nil, userInfo: ["userInfo":""], lastSelected: lastSelected, settingNotificationName: MDFontSettingKeys.insertPicNoti)

    }
}


