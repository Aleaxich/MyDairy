//
//  MDDateAndWeatherView.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/18.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then


@objcMembers class MDDateAndWeatherView:UIView {
    // 日期标题
    var dateLabel:UILabel = UILabel.init()
    var datePopover:MDDatePopUpView
    var weatherPopover:MDWeatherPopUpView
    // 天气图标
    var weatherIconView:UIImageView
    var weatherLabel:UILabel = UILabel.init()
    var model:MDDairyCommonModel
    
     init(model:MDDairyCommonModel) {
         self.model = model
        // 考虑优化
        datePopover = MDDatePopUpView.init(model: model)
        weatherPopover = MDWeatherPopUpView.init()
         
        weatherIconView = UIImageView().then({
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        })
        super.init(frame: .zero)
        buildSubviews()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildSubviews() {
        datePopover.selectedAction = { [weak self] in
            self?.dateLabel.text = "Date：\($0)"
            let dateFormat = DateFormatter.init()
            dateFormat.dateFormat = "yyyy年MM月dd日"
            self?.model.createdDate = dateFormat.date(from: $0)
        }
        weatherPopover.selectedAction = { [weak self] in
            self?.weatherIconView.image = UIImage.init(named: $0)
            self?.model.weather = $0
        }
                
        self.backgroundColor = .white
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "yyyy年MM月dd日"
        let date = model.createdDate ?? NSDate.now
        model.createdDate = date
        let dateString = "Date：\(dateFormat.string(from: date))"
        dateLabel.text = dateString
        dateLabel.isUserInteractionEnabled = true;
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(popDateView))
        dateLabel.addGestureRecognizer(gesture)
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 200, height: 50))
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(20)
        }
        
        weatherLabel.text = "WEA:"
        self.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel.snp_rightMargin)
            maker.centerY.equalToSuperview()
        }
        if let weather = model.weather {
            weatherIconView.image = UIImage.init(named: weather)
        } else {
            weatherIconView.image = UIImage.init(named: "icon_weather_sunny")
            model.weather = "icon_weather_sunny"
        }
       
        let weatherGesture = UITapGestureRecognizer.init(target: self, action: #selector(popWeatherView))
        weatherIconView.isUserInteractionEnabled = true
        weatherIconView.addGestureRecognizer(weatherGesture)
        self.addSubview(weatherIconView)
        weatherIconView.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 35,height: 35))
            maker.left.equalTo(weatherLabel.snp_rightMargin).offset(10)
            maker.bottom.equalTo(weatherLabel).offset(5)
        }
    }
    
    func popDateView() {
        datePopover.show()
    }
    
    func popWeatherView() {
        weatherPopover.show()
    }
    
    
}
