//
//  CategoryRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import CoreData
import Foundation

class CategoryRepository{
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: VMCategory) {
        let description = NSEntityDescription.entity(forEntityName: VMCategory.entityName, in: context)
        let category = NSManagedObject(entity: description!, insertInto: context)
        category.setValue(vm.id, forKey: VMCategory.colId)
        category.setValue(vm.name, forKey: VMCategory.colName)
        category.setValue(vm.image, forKey: VMCategory.colImage)
        app.saveContext()
    }
    
    func get() throws -> [VMCategory] {
        var categories = [VMCategory]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do {
        let result = try context.fetch(fetch) as! [VMCategory]
        for item in result {
            let vm = VMCategory()
            vm.id = item.id
            vm.name = item.name
            vm.image = item.image
            categories.append(vm)
            
        }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return categories
    }
    
    
    func getByKeyword(keyword: String? = nil) throws -> [VMCategory] {
        var vMCategorys = [VMCategory]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        let result = try context.fetch(fetch) as! [VMCategory]
        if let kw = keyword {
            fetch.predicate = NSPredicate(format: "name like[c] %@ || id like[c] %@", "*\(kw)*","*\(kw)*")
        }
        for item in result {
            let vm = VMCategory()
            vm.id = item.id
            vm.name = item.name
            vm.image = item.image
            vMCategorys.append(vm)
            
        }
        return vMCategorys
    }
    
    func delete(id: UUID) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        let result = try context.fetch(fetch) as! [Category]
        for m in result {
            context.delete(m)
        }
        app.saveContext()
    }
    
    
    func update(_ vMCategory:VMCategory) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vMCategory.id.uuidString)
        let result = try context.fetch(fetch) as! [Category]
        for m in result {
            m.setValue(vMCategory.name, forKey: "name")
            m.setValue(vMCategory.image, forKey: "image")
            app.saveContext()
        }
        app.saveContext()
    }
    
    func isExists( name: String) throws -> Bool {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategory.colName)= %@", name)
        do{
        let result = try context.fetch(fetch) as! [VMCategory]
           return result.count > 0
        }catch{
            throw DataError.entityExistyError("判断数据集合失败")
    }
    
    }

}
