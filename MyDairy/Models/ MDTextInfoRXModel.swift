//
//  MDRXinfoModel.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/4/23.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
 实验 coredata 模型驱动
 */

@objcMembers public class MDTextInfoModel:NSObject,NSSecureCoding,NSCoding {
    
    public static var supportsSecureCoding: Bool { return true }

    var mdTextColorHexString: String {
        didSet {
            colorSubject.onNext(mdTextColorHexString)
        }
    }
    
    var mdTextAligment: Int {
        didSet {
            alignmentSubject.onNext(mdTextAligment)
        }
    }

    var mdFontSize: Int {
        didSet {
            fontSizeSubject.onNext(CGFloat(mdFontSize))
        }
    }

    var mdFontWeight:String {
        didSet {
            fontWeigthSubject.onNext(mdFontWeight)
        }
    }
    
    var alignmentSubject = BehaviorSubject<Int>(value: -1)

    var colorSubject = BehaviorSubject<String>(value: "")

    var fontSizeSubject = BehaviorSubject<CGFloat>(value: 20)

    var fontWeigthSubject = BehaviorSubject<String>(value: "")
    
    public func encode(with coder: NSCoder) {
        coder.encode(mdTextColorHexString, forKey: "mdTextColorHexString")
        coder.encode(mdTextAligment, forKey: "mdTextAligment")
        coder.encode(mdFontSize, forKey: "mdFontSize")
        coder.encode(mdFontWeight, forKey: "mdFontWeight")
    }
    
    /// 新模型
    override init() {
        self.mdTextColorHexString = "#000000"
        self.mdTextAligment = 0
        self.mdFontWeight = ""
        self.mdFontSize = 20
    }
    
    required public init?(coder: NSCoder) {
        self.mdTextColorHexString = coder.decodeObject(of: NSString.self, forKey: "mdTextColorHexString")! as String
        self.mdTextAligment = coder.decodeInteger(forKey: "mdTextAligment")
        self.mdFontSize = coder.decodeInteger(forKey: "mdFontSize")
        self.mdFontWeight = (coder.decodeObject(of: NSString.self, forKey: "mdFontWeight") ?? "") as String
    }
    
    public func kvo() {
        alignmentSubject.onNext(self.mdTextAligment)
        colorSubject.onNext(self.mdTextColorHexString)
        fontSizeSubject.onNext(CGFloat(self.mdFontSize))
        fontWeigthSubject.onNext(self.mdFontWeight)
    }
}

extension Reactive where Base:MDTextInfoModel {
    public var mdTextAligment:Binder<Int> {
        return Binder(self.base) { model,alignment in
            model.mdTextAligment = alignment
        }
    }
    
    public var mdTextColorHexString:Binder<String> {
        return Binder(self.base) { model,color in
            model.mdTextColorHexString = color
        }
    }
}
