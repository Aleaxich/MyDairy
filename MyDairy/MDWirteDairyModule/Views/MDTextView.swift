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
    
    
    
    lazy var backGroundView = UIScrollView().then{
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.contentSize = CGSizeMake(SCREEN_WIDTH_SWIFT, self.frame.size.height)
    }
    
    init(frame:CGRect, model:MDDairyCommonModel) {
        self.contextManager = MDContextManager.init(model: model)
        super.init(frame: frame)
        contextManager.textView = textView
        textView.delegate = self.contextManager
        contextManager.insertPicAction = {[weak self] in
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
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 35))
        let item = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([item], animated: false)
        textView.inputAccessoryView = toolbar
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
        picCollectionView.loadData(imageDataList: imageDataList)
        
        textView.snp.remakeConstraints { make in
            make.top.equalTo(picCollectionView.snp_bottomMargin)
            make.width.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        layoutIfNeeded()
    }
    
    func caretChange() {
        var sltRange = textView.selectedTextRange!
        let pos = textView.position(within: sltRange, farthestIn: .down)
        var caretRect = textView.caretRect(for: pos!)
        caretRect = textView.convert(caretRect, to: backGroundView)
        let caretMaxY = caretRect.maxY + 100
        let kbMinY = kbRect.minY
        if kbMinY < caretMaxY {
            backGroundView.contentOffset = CGPoint(x: 0, y: caretMaxY - kbMinY + 50)
        }
    }
    
    /// 计算图片尺寸
    func calculatePicViewSize(image:UIImage) -> CGSize {
        if image.size.width < picViewDefualtWidth && image.size.height < picViewDefualtHeight {
            return CGSize(width:picViewDefualtWidth , height: picViewDefualtHeight)
        } else if image.size.width > picViewDefualtWidth && image.size.height > picViewDefualtHeight {
            let scale:CGFloat = image.size.width / image.size.height
            if image.size.width > image.size.height {
                let height:CGFloat = picViewDefualtWidth / scale
                return CGSize(width: picViewDefualtWidth, height: height)
            } else if image.size.width < image.size.height {
                let width = picViewDefualtHeight * scale
                return CGSize(width: width, height: picViewDefualtHeight)
            }
        }
        return CGSize(width: picViewDefualtWidth, height: picViewDefualtHeight)
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
        
}

