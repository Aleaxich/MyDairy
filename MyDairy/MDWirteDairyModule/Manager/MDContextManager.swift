//
//  MDContextManager.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/15.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import RxSwift

// MARK: 文档管理类
/*
 1. 保存文档
 2. 清空文档
 3. 删除文档
 4. 是否是强制退出 不确定是否在这写
 5. 修改字体格式
 6. 添加图片
 */

/*
 1.草稿与已完成的都会存储起来，草稿在草稿列表，已完成的在已完成列表
 */
@objcMembers class MDContextManager :NSObject{
    weak var textView:UITextView!
    var coreDataManager:MDCoreDataManager
    var model:MDDairyCommonModel
    /// 当前文本字体
    var textFontName:String =  ".SFUI-Regular"
    /// 当前文本字体大小
    var textFontSize:Int = 20
    var imageList:[NSData]?
    ///有改动但是未保存
    var saved = true
    var insertPicAction:((_ imageDataList:[NSData])->())?
    var caretChange:(()->())?
    var disposeBag = DisposeBag()
    
      init(model:MDDairyCommonModel) {
        coreDataManager = MDCoreDataManager.shareInstance
        self.model = model
        super.init()
        setupNoti()
    }
    
    
    /// 解析模型
    func decodeModel() {
        textView.text = model.text
        let color = (model.textInfo?.mdTextColorHexString ?? "#000000") as String
        textView.textColor = UIColor(hexString: color)
        textView.textAlignment = model.textInfo?.mdTextAligment ?? .left
        let fontName = model.textInfo?.mdFontName ?? textFontName
        let fontSize = model.textInfo?.mdFontSize ?? textFontSize
        textView.font = UIFont.init(name: fontName, size: CGFloat(fontSize))
        // 加粗的逻辑待确认
        let fontWeight = model.textInfo?.mdFontWeight ?? UIFont.Weight.regular
        textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: fontWeight)
        // 如果解析出图片
        if model.textInfo?.imageList.count != 0 {
            imageList = model.textInfo?.imageList as? [NSData]
        }
    }
    
    
    /// 保存到文档
    func saveContext() {
        // 如果是草稿或是之前的context
        model.text = textView.text
        if model.draft || model.finished {
            model.draft = false
            coreDataManager.changeDataWithModel(model: model)
        } else {
            model.orderNum = Int32(Date().timeIntervalSince1970)
            model.finished = true
            coreDataManager.addCoreDataWithModel(dairyModel: model)
        }
        saved = true;
    }
    
    // 删除文档
    func CleanContext() {
        textView?.text = nil
        coreDataManager.clean()
    }
    
    /// 保存为草稿
    ///  暂时不需要草稿功能
    func SaveContextToDraft() {
        model.text = textView.text
        //之前就是草稿或已经完成
        if model.draft || model.finished {
            model.finished = false
            coreDataManager.changeDataWithModel(model: model)
        } else {
            //新文件保存为草稿
            model.draft = true
            model.orderNum = Int32(Date().timeIntervalSince1970)
            coreDataManager.addCoreDataWithModel(dairyModel: model)
        }
    }
    
    // 退出编辑界面
    func textViewWillExit() {
        let vc = MDBaseFuncHelper.mdGetCurrentShowViewController()
        if saved {
            if vc.isKind(of: MDWriteNoteViewController.self) {
                vc.navigationController?.popViewController(animated: true)
            }
            CleanContext()
        } else {
            let alert = UIAlertController.init(title: "确定退出？", message: "未保存的改动将会丢失哦～", preferredStyle: .alert)
            let exitAction = UIAlertAction.init(title: "退出", style: .destructive) {[weak self] (action) in
                self?.CleanContext()
                vc.navigationController?.popViewController(animated: true)
            }
            let saveAction = UIAlertAction.init(title: "保存", style: .default) { [weak self](action) in
                self?.saveContext()
                vc.navigationController?.popViewController(animated: true)
            }
            alert.addAction(exitAction)
            alert.addAction(saveAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    //增加图片
    func insertPictureToTextView(image:UIImage) {
        guard  model.textInfo?.imageList.count ?? 0 < 9 else {
            SVProgressHUD.showError(withStatus: "多添加 9 张照片")
            SVProgressHUD.dismiss(withDelay: 0.5)
            return
        }
        
        model.textInfo?.imageList.add(image.pngData() as Any)
        saved = false
        guard let insertPic = insertPicAction else { return }
        insertPic(model.textInfo?.imageList as! [NSData])
    }
    

    //意外退出
    func isUnexpectedExitLastTime() -> Bool {
        false
    }
    
    deinit {
        
    }
}








