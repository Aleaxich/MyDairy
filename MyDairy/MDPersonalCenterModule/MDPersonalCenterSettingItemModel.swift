//
//  MDPersonalCenterSettingItemModel.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/4/16.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

struct MDPersonalCenterSettingItemModel {
    /// 标题
    var title:String
    /// 图片名称
    var image:String
    /// 点击动作
    var selectedAction:() -> ()
}
