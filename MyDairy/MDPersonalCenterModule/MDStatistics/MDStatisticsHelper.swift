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
    var mdTotalImagesSum = 0
    /// 文字总数
    var mdTotalWordsSum = 0
    /// 日记篇数
    var mdTotalDairySum = 0
    
    static let sharedInstance = MDStatisticsHelper()
    
    private override init() {}
    
    override public class func copy() -> Any {
        MDStatisticsHelper.sharedInstance
    }
    
    public override class func mutableCopy() -> Any {
        MDStatisticsHelper.sharedInstance
    }
    
    
    
    public func calculate(models:[MDDairyCommonModel]) {
        guard models.count != 0 && models[0].createdDate != nil else { return }
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
                // 保存上个月份的计算数据
                saveToUserDefault(imagesSum: imagesSum, wordsSum: wordsSum, dairySum: dairySum,monthStringKey: currentMonth)
                // 得到新的计算月份
                currentMonth = self.monthString(date: $0.createdDate! as NSDate)
                imagesSum = $0.imageList?.count ?? 0
                wordsSum = $0.text?.count ?? 0
                dairySum = 1
            }
            saveToUserDefault(imagesSum: imagesSum, wordsSum: wordsSum, dairySum: dairySum,monthStringKey: currentMonth)
            mdTotalImagesSum += $0.imageList?.count ?? 0
            mdTotalWordsSum += $0.text?.count ?? 0
            mdTotalDairySum += 1
        }
    }
    
    /// 重制数据
    func resetData() {
        mdTotalImagesSum = 0
        mdTotalWordsSum = 0
        mdTotalDairySum = 0
    }
    
    func saveToUserDefault(imagesSum: Int, wordsSum: Int, dairySum: Int,monthStringKey: String) {
        let model = MDMonthlyStatistics(imagesSum: imagesSum, wordsSum: wordsSum, dairySum: dairySum)
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        UserDefaults.standard.set(encodedData, forKey: monthStringKey)
    }
    
    /// NSDate 转为月份字符串
    public func monthString(date:NSDate) -> String {
        let dateFormer = DateFormatter()
        dateFormer.dateFormat = "yyyy.MM"
        return dateFormer.string(from: date as Date)
    }
}
