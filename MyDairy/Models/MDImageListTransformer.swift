//
//  MDImageListTransformer.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/5/5.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

@objcMembers public class MDImageListTransformer:ValueTransformer {
    
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let arr = value as? Array<NSData> else{ return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject:arr, requiringSecureCoding: true)
            return data
        } catch {
            assertionFailure("转换失败")
            return nil
        }
    }
    
    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else{return nil}
        do {
            let arr = try NSKeyedUnarchiver.unarchivedObject(ofClass:NSMutableArray.self,  from:data as Data)
            return arr
        } catch {
            assertionFailure("转换失败")
            return nil
        }
    }
    
    public override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    public override class func transformedValueClass() -> AnyClass {
        NSMutableArray.self
    }

}
