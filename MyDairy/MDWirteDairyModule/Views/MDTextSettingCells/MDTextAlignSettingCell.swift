//
//  MDTextAlignSettingCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/4/23.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import UIKit
import Then
import RxCocoa
import RxSwift




public class MDTextSettingButton: UIButton {
    var alignmentInfo:Int = 0
    var colorInfo:String = ""
    var sizeInfo:CGFloat = 0
    var weightInfo:String = ""
    var showBoarder = false
    
    public override var isSelected: Bool {
        didSet {
            if isSelected && showBoarder {
                self.layer.borderColor = UIColor(hexString: "#FFF0F5").cgColor
                self.layer.borderWidth = 2
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0
            }
        }
    }
    
    func showBorderWhenSelected() {
      _ = self.rx.observeWeakly(Bool.self, "isSelected")
            .subscribe(onNext: { isSelected in
                if isSelected! {
                    self.layer.borderColor = UIColor(hexString: "#FFF0F5").cgColor
                    self.layer.borderWidth = 2
                } else {
                    self.layer.borderColor = UIColor.clear.cgColor
                    self.layer.borderWidth = 0
                }
            })
        
           
    }
    
}

/// 设置文字位置
public class MDTextAlignSettingCell: UITableViewCell {
    
    var model:MDTextInfoModel?
    
    lazy var bag = DisposeBag()
    
    lazy var titleLabel = UILabel().then { 
        $0.text = "对齐"
        $0.textAlignment = .left
    }
    
    lazy var button1 = MDTextSettingButton().then{
        $0.setImage(UIImage(named: "icon_setting_left"), for: .normal)
        $0.setImage(UIImage(named: "icon_setting_left_selected"), for: .selected)
        $0.alignmentInfo = 0
    }
    
    lazy var button2 = MDTextSettingButton().then{
        $0.setImage(UIImage(named: "icon_setting_center"), for: .normal)
        $0.setImage(UIImage(named: "icon_setting_center_selected"), for: .selected)
        $0.alignmentInfo = 1

    }
    
    lazy var button3 = MDTextSettingButton().then{
        $0.setImage(UIImage(named: "icon_setting_right"), for: .normal)
        $0.setImage(UIImage(named: "icon_setting_right_selected"), for: .selected)
        $0.alignmentInfo = 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(alignment:Int) {
        let buttons = [button1,button2,button3]
        for button in buttons {
            button.isSelected = button.alignmentInfo == alignment
        }
    }
    
    func setupSubviews() {
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
              stackView.addArrangedSubview(button1)
              stackView.addArrangedSubview(button2)
              stackView.addArrangedSubview(button3)
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp_rightMargin).offset(10)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 300, height: 50))
        }
    }
    

    
    func setupKVO() {
        let buttons = [button1,button2,button3]
        let selectedButton = Observable.from(
            buttons.map({ button in
                button.rx.tap.map {
                    button
                }
            })
        ).merge()
        

        for button in buttons {
            selectedButton.map { $0 == button }
                .bind(to: button.rx.isSelected)
                .disposed(by: bag)
        }
        
        selectedButton.map {
            $0.alignmentInfo
        }.bind(to:model!.rx.mdTextAligment)
            .disposed(by: bag)
    }

}


//extension Reactive where Base:MDTextSettingButton {
//    public var alignInfo:Binder<NSTextAlignment> {
//        return Binder(self.base) { button,alignment in
//            button.alignmentInfo = alignment
//        }
//    }
//}
