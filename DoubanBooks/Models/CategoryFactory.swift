//
//  CategoryFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import CoreData
import Foundation

final class CategoryFactory{
    
    var repository: Repository<VMCategory>
    var app: AppDelegate?
    
   private static var instance: CategoryFactory?
    
private  init(_ app:AppDelegate) {
    repository = Repository<VMCategory>(app)
    }
    static func getInstance(_ app: AppDelegate)->CategoryFactory{
        if let obj=instance{
            return obj
        }else{
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = CategoryFactory(app)
                }
            })
       return instance!
    }
        
    }
    func getAllCategories()throws -> [VMCategory]  {
        return try repository.get()
    }
    
    func addCategory(category:VMCategory) -> (Bool,String?) {
        do{
            if try repository.isEntityExists([VMCategory.colName], keyword: category.name!){
                return(false,"同样类别已经存在")
                
            }
            repository.insert(vm: category)
            return(true,nil)
                
            }catch DataError.entityExistyError(let info){
             return (false, info)
        }catch{
            return(false,error.localizedDescription)
        }
        }
    
    
    func getBookCountOfCategory(category id:UUID) -> Int? {
        do{
            return try
                BookFactory.getInstance(app!).getBooksOf(category: id).count
        }catch{
            return nil

        }
    }
    
    
    
    
    func remove(category: VMCategory) -> (Bool,String?) {
        if let count = getBookCountOfCategory(category: category.id){
            if count > 0 {
                 return (false,"存在该类别图书，不能删除")
            }
           
        }else{
            return (false,"无法获取类别信息")
        }
        do{
            
            try repository.delete(id: category.id)
            return(true,nil)
        }catch DataError.deleteExtityError(let info){
            return(false,info)
            
        }catch{
            return (false,error.localizedDescription)
        }
    }
    }
    

    
extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        
        objc_sync_enter(self)
        
        defer {
            objc_sync_exit(self)
        }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        
        block()
        
    }
    
}
