//
//  MDContextManager+RX.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/27.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/*
 textview <-> model <-> setting 界面
 */


extension MDContextManager {
    
    /// 输入序列
   public struct input {
       let setupSubview: Driver<Void>
        let alignmentButtonTap: Driver<Int>
        let colorButtonTap: Driver<String>
        let sizeButtonTap: Driver<CGFloat>
        let boldButtonTap: Driver<String>
        let insertButtonTap: Driver<Void>
    }
    
    /// 输出序列
    public struct output {
        let datasource:Driver<[MDWriteNoteSettingPopover.CellSectionModel]>
        let aligmentDriver:Driver<NSTextAlignment>
        let colorDriver:Driver<String>
        let fontDriver:Driver<CGFloat>
        let boldDriver:Driver<String>
    }
    
    /// 完成序列转换
    func transform(input:input) -> Driver<[MDWriteNoteSettingPopover.CellSectionModel]> {
        
        let setup = input.setupSubview
            .flatMapLatest {[weak self] _ in
            self!.setup()
                .asDriver(onErrorJustReturn: [])
        }
        
        let alignTap = input.alignmentButtonTap
            .flatMapLatest { [weak self] alignment in
                self!.changeAlignment(alignment: alignment)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let colorTap = input.colorButtonTap
            .flatMapLatest { [weak self] color in
                self!.changeColor(color: color)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let changeSize = input.sizeButtonTap
            .flatMapLatest { [weak self] size in
                self!.changeSize(size: size)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let changeBold = input.boldButtonTap
            .flatMapLatest { [weak self] bold in
                self!.changeBold(bold: bold)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let insertPic = input.insertButtonTap.flatMapLatest { [weak self] _ in
            self!.insertPictureAction()
                .asDriver(onErrorJustReturn: [])
        }
        
        return Driver.merge(setup,alignTap,colorTap,changeSize,changeBold,insertPic)
    }
    
    func setup() -> Single<[MDWriteNoteSettingPopover.CellSectionModel]> {
        return Single.just(createModels())
    }
    
    func insertPictureAction() -> Single<[MDWriteNoteSettingPopover.CellSectionModel]> {
        importPicture()
        return Single.just(createModels())
    }
    
    
    func changeAlignment(alignment:Int) -> Single<[MDWriteNoteSettingPopover.CellSectionModel]> {
        saved = false
        model.textInfo?.mdTextAligment = alignment
        return Single.just(createModels())
    }
    
    func changeColor(color:String) -> Single<[MDWriteNoteSettingPopover.CellSectionModel]> {
        saved = false
        model.textInfo?.mdTextColorHexString = color
        return Single.just(createModels())
    }
    
    func changeSize(size:CGFloat) -> Single<[MDWriteNoteSettingPopover.CellSectionModel]> {
        saved = false
        model.textInfo?.mdFontSize = Int(size)
        fontSizeOB.onNext(size)
        return Single.just(createModels())
    }
    
    func changeBold(bold:String) -> Single<[MDWriteNoteSettingPopover.CellSectionModel]> {
        saved = false
        model.textInfo?.mdFontWeight = bold
        return Single.just(createModels())

    }
    
    func createModels() -> [MDWriteNoteSettingPopover.CellSectionModel] {
        let model = MDSettingInfoModel(alignment: model.textInfo?.mdTextAligment ?? 0, color: model.textInfo?.mdTextColorHexString ?? "#696969", bold: model.textInfo?.mdFontWeight ?? ".regular", size: CGFloat(model.textInfo?.mdFontSize ?? 20))
        return [MDWriteNoteSettingPopover.CellSectionModel(items: [model,model,model,model,model])]
    }
    
    func setupNoti() {
        // 修改日期天气自动保存
        self.rx
            .observeWeakly(String.self, "model.weather")
            .skip(1)
            .subscribe{ value in
//                self.saved = false
             }
            .disposed(by: bag)
       
     //TODO: 注释createdDate 后续添加日期选择日记功能
//        self.rx
//            .observeWeakly(Date.self, "model.createdDate")
//            .skip(1)
//            .subscribe{ value in
//                self.saved = false
//             }
//            .disposed(by: bag)
    }

}

