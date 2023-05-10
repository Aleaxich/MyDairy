//
//  MDTextView.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/27.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxCocoa

class MDTextView:UIView {
    
    var contextManager:MDContextManager
    // 文字
    lazy var textView = UITextView().then{
        $0.isScrollEnabled = false
    }
    // 封面
    lazy var picView:UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    lazy var bag: DisposeBag = DisposeBag()
    /// 封面图片
    var pic:UIImage?
    /// 默认图片高度
    let picViewDefualtHeight:CGFloat = 200
    /// 默认图片宽度
    let picViewDefualtWidth:CGFloat = 300
    /// 键盘尺寸
    var kbRect:CGRect = .zero
    /// 图集
    lazy var picCollectionView:MDPicturesView = MDPicturesView(frame: .zero)
    
    /// 弹窗
    var settingPopover:MDWriteNoteSettingPopover

    var fontSize:CGFloat = 20
    
    var infoModel:MDTextInfoModel
    
    lazy var backGroundView = UIScrollView().then{
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.contentSize = CGSizeMake(SCREEN_WIDTH_SWIFT, self.frame.size.height)
    }
    
    
    init(frame:CGRect, model:MDDairyCommonModel) {
        infoModel = model.textInfo!
        contextManager = MDContextManager.init(model: model)
        settingPopover = MDWriteNoteSettingPopover(contextManager: contextManager)
        super.init(frame: frame)
        contextManager.textView = textView
        textView.delegate = self.contextManager
        contextManager.insertPicAction = {[weak self] in
            print("$0当前对象地址为: \(Unmanaged<AnyObject>.passUnretained($0 as! AnyObject).toOpaque())")
            self?.changeToPicView($0)
        }
        contextManager.caretChange = {[weak self] in
            self?.caretChange()
        }
        noti()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .take(until: self.rx.deallocated)
            .subscribe(onNext: { _ in
            // 键盘尺寸归零
            self.kbRect = .zero
            self.backGroundView.contentOffset = .zero
            }).disposed(by: bag)
        
    
    }
    
    @objc func keyBoardDidAppear(noti:Notification) {
        let userInfo = noti.userInfo!
        kbRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    }
    
    /// 解析模型
    func installModel() {
        contextManager.decodeModel()
        setupSubviews()
    }
    
    func setupSubviews(){
        
        self.backgroundColor = .white
        self.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backGroundView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        infoModel.kvo()
        infoModel.alignmentSubject.asDriver(onErrorJustReturn: -1)
            .map {
                if $0 == -1 || $0 == 0 {
                    return NSTextAlignment.left
                } else if $0 == 1 {
                    return NSTextAlignment.center
                } else {
                    return NSTextAlignment.right
                }
            }.drive(textView.rx.textAlignment)
            .disposed(by: bag)
        
        infoModel.colorSubject.asDriver(onErrorJustReturn: "")
            .map { UIColor(hexString: $0) }
            .drive(textView.rx.textColor)
            .disposed(by: bag)
        
        infoModel.fontSizeSubject.asDriver(onErrorJustReturn: 20)
            .map {[weak self] in
                self?.fontSize = $0
                return UIFont(name: ".SFUI-Regular", size: $0)
            }
            .drive(textView.rx.font)
            .disposed(by: bag)

        infoModel.fontWeigthSubject.asDriver(onErrorJustReturn: "")
            .map {
                if $0 == "bold" {
                    return UIFont.systemFont(ofSize: self.fontSize, weight: UIFont.Weight.bold)
                } else {
                    return UIFont.systemFont(ofSize: self.fontSize, weight: UIFont.Weight.regular)
                }
            }.drive(textView.rx.font)
            .disposed(by: bag)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 35))
        let item = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([item], animated: false)
        textView.inputAccessoryView = toolbar
        
        picCollectionView.deleteAllPictures = {[weak self] in
            self!.removePicView()
        }
        
        picCollectionView.deletePicture = {[weak self] index in
            self!.contextManager.deletePicture(index: index)
        }
        /// 把 model 的 imagelist 传进去
        if contextManager.imageList != nil {
            changeToPicView(contextManager.imageList!)
        }
    }
    
    func changeToPicView(_ imageDataList: [NSData]) {
        backGroundView.addSubview(picCollectionView)
        picCollectionView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: SCREEN_WIDTH_SWIFT, height:350))
            make.top.centerX.equalToSuperview()
        }
        print("imageDataList当前对象地址为: \(Unmanaged<AnyObject>.passUnretained(imageDataList as! AnyObject).toOpaque())")
        picCollectionView.loadData(imageDataList: imageDataList)
        
        
        textView.snp.remakeConstraints { make in
            make.top.equalTo(picCollectionView.snp_bottomMargin)
            make.width.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        layoutIfNeeded()
    }
    
    func removePicView() {
        if picCollectionView.superview != nil {
            picCollectionView.removeFromSuperview()
            self.textView.snp.remakeConstraints { make in
                make.edges.equalTo(self)
            }
        }
    }
    
    func caretChange() {
        let sltRange = textView.selectedTextRange!
        let pos = textView.position(within: sltRange, farthestIn: .down)
        var caretRect = textView.caretRect(for: pos!)
        caretRect = textView.convert(caretRect, to: backGroundView)
        let caretMaxY = caretRect.maxY + 100
        let kbMinY = kbRect.minY
        if kbMinY < caretMaxY {
            backGroundView.contentOffset = CGPoint(x: 0, y: caretMaxY - kbMinY + 50)
        }
    }
    
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    func textViewWillExit(){
        contextManager.textViewWillExit()
    }
        
        
    func saveContext() {
        contextManager.saveContext()
    }
        
    func CleanContext() {
        contextManager.CleanContext()
    }
        
    // 保存为草稿
    func SaveContextToDraft() {
        contextManager.SaveContextToDraft()
    }
    
    func stopEditing(){
        textView.endEditing(true)
    }
    
    func show(){
        settingPopover.show()
    }
        
}

