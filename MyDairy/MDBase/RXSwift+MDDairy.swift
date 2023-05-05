//
//  RXSwift+MDDairy.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/2.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


extension Reactive where Base: UITextView {
    var font: Binder<UIFont> {
        Binder(self.base){ (textview,font) in
            textview.font = font
        }
    }
}
