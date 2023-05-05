//
//  MDWriteNoteSettingViewController.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/20.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Then
import RxDataSources


/*
 1.所选择的对应
 
 */

final class MDWriteNoteSettingPopover: MDBasePopover,UITableViewDelegate {
    var manager:MDContextManager
    
    var bag = DisposeBag()
    
    /// 点击文字位置按钮
    private let alignmentButtonTap = PublishSubject<Int>()
    
    /// 颜色选择
    private let colorButtonTap = PublishSubject<String>()
    
    /// 字体大小选择
    private let sizeButtonTap = PublishSubject<CGFloat>()
    
    ///是否加粗按钮
    private let boldButtonTap = PublishSubject<String>()
    
    /// 插入封面
    private let insertButtonTap = PublishSubject<Void>()
    
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.gray
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MDTextAlignSettingCell.self, forCellReuseIdentifier: "MDTextAlignSettingCell")
        tableView.register(MDTextColorSettingCell.self, forCellReuseIdentifier: "MDTextColorSettingCell")
        tableView.register(MDTextFontSizeSettingCell.self, forCellReuseIdentifier: "MDTextFontSizeSettingCell")
        tableView.register(MDTextFontWeightSettingCell.self, forCellReuseIdentifier: "MDTextFontWeightSettingCell")

        return tableView
    }()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<CellSectionModel> = {
        return RxTableViewSectionedReloadDataSource<CellSectionModel>(configureCell: { [weak self](_, tableView, indexPath, item) -> UITableViewCell in
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MDTextAlignSettingCell") as! MDTextAlignSettingCell
                cell.load(alignment:item.alignment)
                cell.button1.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.alignmentButtonTap.onNext(0)
                    })
                    .disposed(by: self!.bag)
                cell.button2.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.alignmentButtonTap.onNext(1)
                    })
                    .disposed(by: self!.bag)
                cell.button3.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.alignmentButtonTap.onNext(2)
                    })
                    .disposed(by: self!.bag)
                return cell
            }
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MDTextColorSettingCell") as! MDTextColorSettingCell
                cell.load(colorHexString:item.color)
                cell.button1.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.colorButtonTap.onNext("#000000")
                    })
                    .disposed(by: self!.bag)
                
                cell.button2.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.colorButtonTap.onNext("#696969")
                    })
                    .disposed(by: self!.bag)
                
                cell.button3.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.colorButtonTap.onNext("#FF6347")
                    })
                    .disposed(by: self!.bag)
                
                cell.button4.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.colorButtonTap.onNext("#D2691E")
                    })
                    .disposed(by: self!.bag)
                
                cell.button5.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.colorButtonTap.onNext("#D2B48C")
                    })
                    .disposed(by: self!.bag)
                
                return cell

            }
            
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MDTextFontSizeSettingCell") as! MDTextFontSizeSettingCell
                cell.load(size:item.size)
                cell.button1.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.sizeButtonTap.onNext(16)
                    })
                    .disposed(by: self!.bag)
                
                cell.button2.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.sizeButtonTap.onNext(18)
                    })
                    .disposed(by: self!.bag)
                
                cell.button3.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.sizeButtonTap.onNext(20)
                    })
                    .disposed(by: self!.bag)
                
                cell.button4.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.sizeButtonTap.onNext(22)
                    })
                    .disposed(by: self!.bag)
                
                cell.button5.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.sizeButtonTap.onNext(24)
                    })
                    .disposed(by: self!.bag)
                
                return cell

            }
            
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MDTextFontWeightSettingCell") as! MDTextFontWeightSettingCell
                cell.load(weight: item.bold)
                cell.button1.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.boldButtonTap.onNext("regular")
                    })
                    .disposed(by: self!.bag)
                cell.button2.rx.tap
                    .subscribe(onNext: { [weak self] (_) in
                        self!.boldButtonTap.onNext("bold")
                    })
                    .disposed(by: self!.bag)
            
                return cell
            }
            
        

            return UITableViewCell()
        })
    }()

    
    init(contextManager:MDContextManager) {
        manager = contextManager
        super.init()
        setupSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
            self.addSubview(tableView)
            tableView.snp.makeConstraints { (maker) in
                maker.height.equalTo(300)
                maker.bottom.width.centerX.equalToSuperview()
            }
        setupRX()
    }
    
  
    func setupRX() {
        let setupSubviews = Driver<Void>.just(())
        let input = MDContextManager.input(setupSubview: setupSubviews,
                                 alignmentButtonTap:alignmentButtonTap.asDriver(onErrorJustReturn: 0),
                                  colorButtonTap:colorButtonTap.asDriver(onErrorJustReturn: ""),
                                  sizeButtonTap: sizeButtonTap.asDriver(onErrorJustReturn: 0),
                                  boldButtonTap: boldButtonTap.asDriver(onErrorJustReturn: ""),
                                  insertButtonTap: insertButtonTap.asDriver(onErrorJustReturn: ())
                                )
        manager.transform(input: input).asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            0.001
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            60
    }
    
}


///  数据模型
extension MDWriteNoteSettingPopover {
    struct CellSectionModel {
        var items: [Item]
    }
}

extension MDWriteNoteSettingPopover.CellSectionModel: SectionModelType {
    typealias Item = MDSettingInfoModel
    init(original: MDWriteNoteSettingPopover.CellSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
