//
//  Repository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
class Repository<T:DataViewModelDelegate> where T:NSObject{
    var app: AppDelegate
    var context: NSManagedObjectContext
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    func insert(vm: T) {
        let description = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
        let obj = NSManagedObject(entity: description!, insertInto: context)
        for (key, value) in vm.entiyPairs(){
            obj.setValue(value, forKey: key)
        }
        
        
        app.saveContext()
    }
    func isEntityExists(_ cols: [String],keyword: String) throws-> Bool {
        var format = ""
        var  args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
    }
    format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch) as! [VMBook]
            return result.count > 0
        }catch{
            
           throw DataError.entityExistyError("判断数据存在失败")
        }
        
}
    func get()throws -> [T] {
         var items = [T]()
         let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)

        do{
            let result = try context.fetch(fetch) as! [VMBook]
            for c in result{
                let t = T()
                t.packageSelf(result: c as! NSFetchRequestResult)
                items.append(t)
                
            }
            return items
            
        }catch{
            throw DataError.entityExistyError("读取集合数据失败")
        }
    }
    
    // 根据关键词查询某一实体类符合条件的数据，模糊查询
    //
    // - parametter cols: 需要匹配的列如： ["name","publisher"]
    // - parametter keyword: 要搜索的关键词
    // - returns:  视图模型对象集合
    func getBy(_ cols:[String], keyword: String) throws -> [T] {
        var format = ""
        var args = [String]()
        for col in cols{
            format += "\(col) like[c] %@ || "
            args.append("*\(keyword)*")
            
        }
        format.removeLast(3)
        var items = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            for  c in result{
                let t = T()
                t.packageSelf(result: c as! NSFetchRequestResult)
                items.append(t)
            }
            return items
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
    }
    
    // 根据关键词查询某一实体类符合条件的数据，精确查询
    //
    // - parametter cols: 需要匹配的列如： ["name","publisher"]
    // - parametter keyword: 要搜索的关键词
    // - returns:  视图模型对象集合
    func getExplicitlyBy(_ cols:[String], keyword: String) throws -> [T] {
        var format = ""
        var args = [String]()
        for col in cols{
            format += "\(col) like[c] %@ || "
            args.append(keyword)
            
        }
        format.removeLast(3)
        var items = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            for  c in result{
                let t = T()
                t.packageSelf(result: c as! NSFetchRequestResult)
                items.append(t)
            }
            return items
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
    }
    func update(vm:T) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            for(key,value) in vm.entiyPairs(){
                obj.setValue(value, forKey: key)
            }
           
            app.saveContext()
            
        }catch {
            throw DataError.entityExistyError("更新数据失败")
            
        }
    }
    
    
    func delete(id: UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do{
            let result = try context.fetch(fetch)
            for  b in result{
                context.delete(b as! NSManagedObject)
                
            }
            app.saveContext()
        }catch{
            throw DataError.entityExistyError("删除数据失败")
            
        }
        
    }
    
}
