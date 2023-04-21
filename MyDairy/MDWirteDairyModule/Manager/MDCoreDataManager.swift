//
//  MDCoreDataManager.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/14.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Then

/*
 coreData 管理类
 */
@objcMembers public class MDCoreDataManager:NSObject {
     var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let shareInstance = MDCoreDataManager()
    
    //重写 init 等方法
    private override init() {}
    
    public override func copy() -> Any {
        MDCoreDataManager.shareInstance
    }
    
    public override func mutableCopy() -> Any {
        MDCoreDataManager.shareInstance
    }
    
    /// 获取 context
    private func getContext() -> NSManagedObjectContext {
            return  delegate.persistentContainer.viewContext
      }
    
    func getNewDairyModel() -> MDDairyCommonModel {
        let context = self.getContext()
        let model = NSEntityDescription.insertNewObject(forEntityName: "MDDairyCommonModel", into: context)as! MDDairyCommonModel

        return model
    }
    

    // MARK: 增加
    func addCoreDataWithModel(dairyModel:MDDairyCommonModel)  {
        let context = self.getContext()
        guard dairyModel.orderNum != 0  else {return}
        context.insert(dairyModel)
        do{
            try context.save()
            SVProgressHUD.showSuccess(withStatus: "保存成功")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
        catch {
            SVProgressHUD.showError(withStatus: "保存失败")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
        
    }
    
    /// 获取数据
    func getCoreData() -> [MDDairyCommonModel]? {
          let context = self.getContext()
                let entity = NSEntityDescription.entity(forEntityName: "MDDairyCommonModel", in: context)
            let request = NSFetchRequest<MDDairyCommonModel>()
                request.entity = entity
                var arr:[MDDairyCommonModel]
                do {
                    arr = try context.fetch(request)
                    // 过滤无效数据
                    return arr.filter{$0.orderNum != 0}
                } catch  {
                    print("读取数据失败")
                    return nil
                }
    }
    
    // MARK: 删除
    func deleteWithOrderNum(_ orderNum:Int32) {
        let context = self.getContext()
        let request = NSFetchRequest<MDDairyCommonModel>(entityName: "MDDairyCommonModel")
        request.predicate = NSPredicate(format: "orderNum = " + "\(orderNum)")
        do {
             let results:[MDDairyCommonModel]? = try context.fetch(request)
            for model in results! {
                context.delete(model)
                do{
                    try context.save()
                    SVProgressHUD.showSuccess(withStatus: "删除成功")
                    SVProgressHUD.dismiss(withDelay: 0.5)
                }
                catch {
                    SVProgressHUD.showError(withStatus: "删除失败")
                    SVProgressHUD.dismiss(withDelay: 0.5)
                }             }
         } catch  {
             print("删除失败")
        }
    }
    
    /// 根据 ordernum 获得对象
    func getDataWithOrderNum(_ orderNum:Int32?) -> MDDairyCommonModel? {
        guard let orderNum = orderNum else { return nil}
        let context = self.getContext()
        let request = NSFetchRequest<MDDairyCommonModel>(entityName: "MDDairyCommonModel")
        request.predicate = NSPredicate(format: "orderNum = " + "\(orderNum)")
        do {
            let results:[MDDairyCommonModel]? = try context.fetch(request)
            guard let trueResult = results else { return nil}
            return trueResult.first
        } catch  {
            SVProgressHUD.showError(withStatus: "获取失败")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
        return nil
    }
        
    // MARK: 改
    func changeDataWithModel(model:MDDairyCommonModel) {
        let context = self.getContext()
        let request = NSFetchRequest<MDDairyCommonModel>(entityName: "MDDairyCommonModel")
        request.predicate = NSPredicate(format: "orderNum = " + "\(model.orderNum)")

        do {
            let results:[MDDairyCommonModel]? = try context.fetch(request)
            guard let trueResult = results else {
                return
            }
            let preModel = trueResult.first!
            preModel.do{
                $0.text = model.text
                $0.image = model.image
                $0.textInfo = model.textInfo
                $0.createdDate = model.createdDate
                $0.weather = model.weather
                $0.mood = model.mood
            }
//            preModel.text = model.text
//            preModel.image = model.image
//            preModel.textInfo = model.textInfo
//            preModel.createdDate = model.createdDate
//            preModel.weather = model.weather
//            preModel.mood = model.mood
            try context.save()
            SVProgressHUD.showSuccess(withStatus: "保存成功")
            SVProgressHUD.dismiss(withDelay: 0.5)
         } catch  {
             SVProgressHUD.showError(withStatus: "保存失败")
             SVProgressHUD.dismiss(withDelay: 0.5)
        }

    }
    
    func clean() {
        let context = self.getContext()
        context.reset()
    }
    
  }

