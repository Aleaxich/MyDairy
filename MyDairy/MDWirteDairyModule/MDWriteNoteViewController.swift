//
//  MDWriteNoteViewController.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import UIKit

@objcMembers class MDWriteNoteViewController: MDBaseViewController {

    var mdTextView:MDTextView
    var dateAndWeatherView:MDDateAndWeatherView

    
    init(model:MDDairyCommonModel?) {
        var realModel:MDDairyCommonModel
        let datas:[NSData] = []
        if model != nil {
            realModel = model!
            realModel.textInfo = model!.textInfo ?? MDTextInfoModel.init()
            realModel.imageList = model!.imageList ?? NSMutableArray(array: datas)
        } else {
            realModel = MDCoreDataManager.shareInstance.getNewDairyModel()
            realModel.textInfo = MDTextInfoModel.init()
            realModel.imageList = NSMutableArray(array: datas)
        }
        realModel.textInfo?.kvo()
        mdTextView = MDTextView.init(frame: .zero, model: realModel)
        self.dateAndWeatherView = MDDateAndWeatherView(model: realModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupSubviews()
    }
    
    
    private func checkDraft() {
        
    }
    
    private func setupSubviews(){
        
        self.setupCustomNavBar()
        mdTextView.installModel()

        self.setNavLeftButtonTitle("", with: UIImage.init(named: "icon_nav_bar_close")!) {
            self.exit()
        }
        self.setNavCenterButtonTitle("", with: UIImage.init(named: "icon_nav_bar_save")!) {
            self.save()
        }
        self.setNavRightButtonTitle("", with: UIImage.init(named: "icon_nav_bar_setting")!) {
            self.mdTextView.stopEditing()
            self.mdTextView.show()
        }
        
        
        self.view.addSubview(dateAndWeatherView)
        dateAndWeatherView.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.height.equalTo(50)
            make.width.centerX.equalToSuperview()
        }
        
        self.view.addSubview(mdTextView)
        mdTextView.snp.makeConstraints { (maker) in
            maker.top.equalTo(dateAndWeatherView.snp_bottomMargin)
            maker.bottom.left.right.equalToSuperview()
        }
    }
    
    @objc func save(){
        mdTextView.saveContext()
        
    }
    
    @objc func exit()  {
        mdTextView.textViewWillExit()
    }
}




