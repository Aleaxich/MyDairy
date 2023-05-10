//
//  MDDatePopUpView.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/18.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation



class MDDatePopUpView: MDBasePopover {
    //日期选择器
    var datePicker:UIDatePicker
    
    var toolbarPicker = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH_SWIFT, height: 50))

        init(model:MDDairyCommonModel) {
         datePicker = UIDatePicker.init()
         datePicker.locale = NSLocale.init(localeIdentifier: "zh") as Locale
         datePicker.datePickerMode = .date
        let date = model.createdDate ?? NSDate.now
         datePicker.setDate(date, animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        super.init()
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        self.addSubview(datePicker)
        self.datePicker.snp.makeConstraints { (maker) in
            maker.width.equalTo(SCREEN_WIDTH_SWIFT)
            maker.height.equalTo(200)
            maker.left.bottom.equalToSuperview()
        }
        
        let cancelItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(dismiss))
        let springItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let confirmItem = UIBarButtonItem.init(title: "确定", style: .plain, target: self, action: #selector(confirmAction))
        toolbarPicker.items = [cancelItem,springItem,confirmItem]
        
        self.addSubview(toolbarPicker)
        toolbarPicker.snp.makeConstraints { (maker) in
            maker.width.equalTo(SCREEN_WIDTH_SWIFT)
            maker.height.equalTo(50)
            maker.bottom.equalTo(datePicker.snp_topMargin)
            maker.centerX.equalToSuperview()
        }
    }
    
    override func cancelAction() {
        dismiss()
    }
    
    override func confirmAction() {
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "yyyy年MM月dd日"
        let dateString = dateFormat.string(from: self.datePicker.date)
        if let selectedAction = selectedAction {
            selectedAction(dateString)
        }
        dismiss()
    }
}
