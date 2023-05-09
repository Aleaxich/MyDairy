//
//  MDStatisticsViewController.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/6.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then
import Charts
import SnapKit
import AAInfographics
import RxSwift
import RxCocoa

public class MDStatisticsViewController: MDBaseViewController {
    lazy var bag = DisposeBag()
    
    lazy var titleLabel = UILabel().then {
        $0.text = "感谢你的一路陪伴"
        $0.font = UIFont(name: "", size: 40)
    }
    
    lazy var line1 = UIView().then {
        $0.backgroundColor = .gray
    }
    
    lazy var line2 = UIView().then {
        $0.backgroundColor = .gray
    }
    
    lazy var dairyCount = UILabel().then {
        $0.text = "篇数"
    }
    
    lazy var textCount = UILabel().then {
        $0.text = "文字"
    }
    
    lazy var picturesCount = UILabel().then {
        $0.text = "图片"
    }
    
    lazy var dairyNum = UILabel().then {
        $0.text = "\(MDStatisticsHelper.sharedInstance.mdDairySum)"
    }
    
    lazy var textNum = UILabel().then {
        $0.text = "\(MDStatisticsHelper.sharedInstance.mdWordsSum)"
    }
    
    lazy var picturesNum = UILabel().then {
        $0.text = "\(MDStatisticsHelper.sharedInstance.mdImagesSum)"
    }
    
    lazy var subButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_arrow_left"), for: .normal)
    }
    
    lazy var addButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_arrow_right"), for: .normal)
    }
    
    lazy var dateLabel = UILabel().then {
        $0.text = "\(currentYear)"
        $0.textAlignment = .center
    }
    
    /// 柱状图
    lazy var columnView = AAChartView()
    
    /// 当前年份
    var currentYear:Int{
        didSet {
            currentList = getStatistics(year: currentYear)
            dateLabel.text = "\(currentYear)"
            
            var dairySumList = [Int]()
            var wordsSumList = [Double]()
            var imagesSumList = [Int]()
            currentList.forEach {
                dairySumList.append($0.dairySum)
                wordsSumList.append(Double($0.wordsSum) / 1000.0)
                imagesSumList.append($0.imagesSum)
            }
            let list:[AASeriesElement] = [
                AASeriesElement()
                    .name("记录数目")
                    .data(dairySumList),
                AASeriesElement()
                    .name("字数（千字）")
                    .data(wordsSumList),
                AASeriesElement()
                    .name("图片总数")
                    .data(imagesSumList)]
            columnView.aa_onlyRefreshTheChartDataWithChartModelSeries(list)
        }
    }
    
    var currentList:[MDMonthlyStatistics] = [MDMonthlyStatistics]()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        currentYear = Int( formatter.string(from: NSDate() as Date))!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        view.addSubview(line1)
        let leading:CGFloat = 10
        line1.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH_SWIFT - leading * 2, 0.5))
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
        }
        
        let stackView = UIStackView.init()
              stackView.axis = .horizontal
              stackView.alignment = .fill
              stackView.spacing = 50
              stackView.distribution = .fillEqually
              stackView.addArrangedSubview(dairyCount)
              stackView.addArrangedSubview(textCount)
              stackView.addArrangedSubview(picturesCount)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(line1.snp_bottomMargin).offset(10)
            maker.left.right.equalTo(line1)
            maker.height.equalTo(20)
        }
        
        let numsStackView = UIStackView.init()
            numsStackView.axis = .horizontal
            numsStackView.alignment = .fill
            numsStackView.spacing = 50
            numsStackView.distribution = .fillEqually
            numsStackView.addArrangedSubview(dairyNum)
            numsStackView.addArrangedSubview(textNum)
            numsStackView.addArrangedSubview(picturesNum)
      
      view.addSubview(numsStackView)
        numsStackView.snp.makeConstraints { (maker) in
          maker.top.equalTo(stackView.snp_bottomMargin).offset(10)
          maker.left.right.equalTo(line1)
          maker.height.equalTo(40)
        }
        
        view.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH_SWIFT - leading * 2, 0.5))
            make.top.equalTo(numsStackView.snp_bottomMargin).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(columnView)
        columnView.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH_SWIFT - 2 * leading, 300))
            make.top.equalTo(line2).offset(30)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(subButton)
        subButton.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(15, 15))
            make.left.equalToSuperview().offset(100)
            make.top.equalTo(columnView.snp_bottomMargin).offset(10)
        }
        
        subButton.rx
            .tap
            .subscribe {[weak self] event in
                self?.currentYear -= 1
        }
        .disposed(by: bag)
        
        addButton.rx
            .tap
            .subscribe {[weak self] event in
                self?.currentYear += 1
        }
        .disposed(by: bag)
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(50, 15))
            make.centerX.equalToSuperview()
            make.centerY.equalTo(subButton)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.size.equalTo(CGSizeMake(15, 15))
            make.right.equalToSuperview().offset(-100)
            make.top.equalTo(columnView.snp_bottomMargin).offset(10)
        }
        
        loadData()
    }

    
    func loadData() {
        // 初始化图表模型
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        currentList = getStatistics(year: Int( formatter.string(from: NSDate() as Date))!)
        var dairySumList = [Int]()
        var wordsSumList = [Double]()
        var imagesSumList = [Int]()
        currentList.forEach {
            dairySumList.append($0.dairySum)
            wordsSumList.append(Double($0.wordsSum) / 1000.0)
            imagesSumList.append($0.imagesSum)
        }
        
               let chartModel = AAChartModel()
                   .chartType(.column)//图表类型
                   .title("数据统计")//图表主标题
                   .inverted(false)//是否翻转图形
                   .yAxisTitle("数量")// Y 轴标题
                   .legendEnabled(true)//是否启用图表的图例(图表底部的可点击的小圆点)
                   .categories(["一月", "二月", "三月", "四月", "五月", "六月","七月", "八月", "九月", "十月", "十一月", "十二月"])
                   .colorsTheme(["#fe117c","#ffc069","#06caf4"])//主题颜色数组
                   .series([
                       AASeriesElement()
                           .name("记录数目")
                           .data(dairySumList)
                           .toDic()!,
                       AASeriesElement()
                           .name("字数（千字）")
                           .data(wordsSumList)
                           .toDic()!,
                       AASeriesElement()
                           .name("图片总数")
                           .data(imagesSumList)
                           .toDic()!])
                
             columnView.aa_drawChartWithChartModel(chartModel)
        
    }
    
    func getStatistics(year:Int) -> [MDMonthlyStatistics] {
        var resList = [MDMonthlyStatistics]()
        for i in  1...12  {
            let currentMonth:String
            if i < 10 {
                currentMonth = "\(year).0\(i)"
            } else {
                currentMonth = "\(year).\(i)"
            }
            if let decodedData = UserDefaults.standard.object(forKey: currentMonth) as? Data {
                let decodedCustomObject = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData)
                if decodedCustomObject != nil {
                    resList.append(decodedCustomObject as! MDMonthlyStatistics)
                }
            } else {
                resList.append( MDMonthlyStatistics.init(imagesSum: 0, wordsSum: 0, dairySum: 0))
            }

        }
        return resList
    }
}
