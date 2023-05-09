//
//  MDStatisticsHelper.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/6.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

class MDMonthlyStatistics:NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(imagesSum, forKey: "imagesSum")
        coder.encode(wordsSum, forKey: "wordsSum")
        coder.encode(dairySum, forKey: "dairySum")
    }
    
    required init?(coder: NSCoder) {
        self.imagesSum = coder.decodeInteger(forKey: "imagesSum")
        self.wordsSum = coder.decodeInteger(forKey: "wordsSum")
        self.dairySum = coder.decodeInteger(forKey: "dairySum")
    }
    
    /// 图片总数
    var imagesSum:Int = 0
    /// 文字总数
    var wordsSum:Int = 0
    /// 日记篇数
    var dairySum:Int = 0
    
     init(imagesSum: Int, wordsSum: Int, dairySum: Int) {
        self.imagesSum = imagesSum
        self.wordsSum = wordsSum
        self.dairySum = dairySum
    }
}

/// 计算数据类
public class MDStatisticsHelper:NSObject {
    
    /// 图片总数
    var mdImagesSum = 0
    /// 文字总数
    var mdWordsSum = 0
    /// 日记篇数
    var mdDairySum = 0
    
    static let sharedInstance = MDStatisticsHelper()
    
    private override init() {}
    
    override public class func copy() -> Any {
        MDStatisticsHelper.sharedInstance
    }
    
    public override class func mutableCopy() -> Any {
        MDStatisticsHelper.sharedInstance
    }
    
    
    
   public func calculate(models:[MDDairyCommonModel]) {
        guard models.count != 0 else { return }
        var currentMonth = self.monthString(date: models[0].createdDate! as NSDate)
        var imagesSum = 0
        var wordsSum = 0
        var dairySum = 0
       resetData()
        models.forEach {
            let tempMonth = self.monthString(date: $0.createdDate! as NSDate)
            // 如果是当前月份
            if (tempMonth == currentMonth) {
                imagesSum += $0.imageList?.count ?? 0
                wordsSum += $0.text?.count ?? 0
                dairySum += 1
            } else {
                let model = MDMonthlyStatistics(imagesSum: imagesSum, wordsSum: wordsSum, dairySum: dairySum)
                let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: currentMonth)
                currentMonth = self.monthString(date: $0.createdDate! as NSDate)
                imagesSum = $0.imageList?.count ?? 0
                wordsSum = $0.text?.count ?? 0
                dairySum = 1
            }
            mdImagesSum += $0.imageList?.count ?? 0
            mdWordsSum += $0.text?.count ?? 0
            mdDairySum += 1
        }
    }
    
    /// 重制数据
    func resetData() {
        mdImagesSum = 0
        mdWordsSum = 0
        mdDairySum = 0
    }
    
    /// NSDate 转为月份字符串
    public func monthString(date:NSDate) -> String {
        let dateFormer = DateFormatter()
        dateFormer.dateFormat = "yyyy.MM"
        return dateFormer.string(from: date as Date)
    }
}
