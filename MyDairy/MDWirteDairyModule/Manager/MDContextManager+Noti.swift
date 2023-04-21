//
//  MDContextManager+Noti.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/27.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

extension MDContextManager {

    func setupNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(alignmentSettingChanged(noti:)), name: NSNotification.Name(rawValue: MDFontSettingKeys.alignmentSettingChanged), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(colorSettingChanged(noti:)), name: NSNotification.Name(rawValue: MDFontSettingKeys.colorSettingChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fontNameSettingChanged(noti:)), name: NSNotification.Name(rawValue: MDFontSettingKeys.fontNameSettingChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fontSizeSettingChanged(noti:)), name: NSNotification.Name(rawValue: MDFontSettingKeys.fontSizeSettingChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fontBoldSettingChanged(noti:)), name: NSNotification.Name(rawValue: MDFontSettingKeys.fontBoldSettingChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(insertPicNoti(noti:)), name: NSNotification.Name(rawValue: MDFontSettingKeys.insertPicNoti), object: nil)
        
        // 修改日期天气自动保存
        self.rx
            .observeWeakly(String.self, "model.weather")
            .skip(1)
            .subscribe{ value in
                self.saved = false
             }
            .disposed(by: disposeBag)
        
        self.rx
            .observeWeakly(Date.self, "model.createdDate")
            .skip(1)
            .subscribe{ value in
                self.saved = false
             }
            .disposed(by: disposeBag)
    }
    
    
    @objc func alignmentSettingChanged(noti:NSNotification) {
            let userInfo = noti.userInfo
        if let alignInfo = userInfo?["userInfo"] {
            self.textView.textAlignment = alignInfo as! NSTextAlignment
            model.textInfo?.mdTextAligment = alignInfo as! NSTextAlignment
        }
        saved = false
    }
    
    @objc func colorSettingChanged(noti:NSNotification) {
            let userInfo = noti.userInfo
        if let colorInfo = (userInfo?["userInfo"])! as? String {
            self.textView.textColor = UIColor(hexString: colorInfo)
            model.textInfo?.mdTextColorHexString = colorInfo
        }
        saved = false
    }
    
    @objc func fontNameSettingChanged(noti:NSNotification) {
        if let fontName = noti.userInfo?["userInfo"] {
            textFontName = (fontName as? String)!
            self.textView.font = UIFont(name: textFontName, size: CGFloat(textFontSize))
            model.textInfo?.mdFontName = textFontName

        }
        saved = false
    }
    
    @objc func fontSizeSettingChanged(noti:NSNotification) {
        if let fontSize = noti.userInfo?["userInfo"] {
            textFontSize = (fontSize as? Int)!
            textView.font = UIFont(name: textFontName , size: CGFloat(textFontSize))
            model.textInfo?.mdFontSize = textFontSize

        }
        saved = false
    }
    
    @objc func fontBoldSettingChanged(noti:NSNotification) {
        if let fontBold = noti.userInfo?["userInfo"] {
            self.textView.font = UIFont.systemFont(ofSize: CGFloat(textFontSize), weight: fontBold as! UIFont.Weight)
            model.textInfo?.mdFontWeight = fontBold as! UIFont.Weight

        }
        saved = false
    }
    
    @objc func insertPicNoti(noti:NSNotification) {
        importPicture()
    }
}
