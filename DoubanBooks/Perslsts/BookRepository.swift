//
//  BookRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
class BookRepository{
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: VMBook) {
        let description = NSEntityDescription.entity(forEntityName: VMBook.entityName, in: context)
        let book = NSManagedObject(entity: description!, insertInto: context)
        book.setValue(vm.id, forKey: VMBook.colId)
        book.setValue(vm.author, forKey: VMBook.colAuthor)
        book.setValue(vm.image, forKey: VMBook.colImage)
        book.setValue(vm.authorintro, forKey: VMBook.colAuthorintro)
        book.setValue(vm.binding, forKey: VMBook.colBinding)
        book.setValue(vm.categoryld, forKey: VMBook.colCategoryld)
        book.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
        book.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
        book.setValue(vm.pages, forKey: VMBook.colPages)
        book.setValue(vm.price, forKey: VMBook.colPrice)
        book.setValue(vm.pubdate, forKey: VMBook.colPubdate)
        book.setValue(vm.publisher, forKey: VMBook.colPublisher)
        book.setValue(vm.summary, forKey: VMBook.colSummary)
        book.setValue(vm.title, forKey: VMBook.colTitle)
        app.saveContext()
}
    
    
    func get() throws -> [VMBook] {
        var books = [VMBook]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            for c in result {
                let vm = VMBook()
                vm.id = c.id
                vm.author = c.author
                vm.image = c.image
                vm.binding = c.binding
                vm.categoryld = c.categoryld
                vm.isbn10 = c.isbn10
                vm.isbn13 = c.isbn13
                vm.pages = c.pages
                vm.price = c.price
                vm.pubdate = c.pubdate
                vm.publisher = c.publisher
                vm.summary = c.summary
                vm.title = c.title
                books.append(vm)
                
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return books
    }
    
    
    
    func getBy(keyword format:String,args:[Any])throws -> [VMBook] {
        var books = [VMBook]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName:
        VMBook.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do{
            let result = try context.fetch(fetch) as! [VMBook]
            for c in result{
                 let vm = VMBook()
                vm.id = c.id
                vm.author = c.author
                vm.image = c.image
                vm.binding = c.binding
                vm.categoryld = c.categoryld
                vm.isbn10 = c.isbn10
                vm.isbn13 = c.isbn13
                vm.pages = c.pages
                vm.price = c.price
                vm.pubdate = c.pubdate
                vm.publisher = c.publisher
                vm.summary = c.summary
                vm.title = c.title
                
                books.append(vm)
            }
            return books
        }catch{
          throw DataError.readCollectionError("读取集合数据失败")
        }
        
    }
    
    
    func isExists(isbn: String) throws -> Bool {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colIsbn10) = %@ || \(VMBook.colIsbn13)" ,isbn,isbn)
        do{
            let result = try context.fetch(fetch) as! [VMBook]
            return result.count > 0
        }catch{
            throw DataError.entityExistyError("判断数据集合失败")
        }
        
    }
    func update(vm:VMBook) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
        let obj = try context.fetch(fetch)[0] as! NSManagedObject
             obj.setValue(vm.id, forKey: VMBook.colId)
             obj.setValue(vm.author, forKey: VMBook.colAuthor)
             obj.setValue(vm.image, forKey: VMBook.colImage)
             obj.setValue(vm.authorintro, forKey: VMBook.colAuthorintro)
             obj.setValue(vm.binding, forKey: VMBook.colBinding)
             obj.setValue(vm.categoryld, forKey: VMBook.colCategoryld)
             obj.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
             obj.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
             obj.setValue(vm.pages, forKey: VMBook.colPages)
             obj.setValue(vm.price, forKey: VMBook.colPrice)
             obj.setValue(vm.pubdate, forKey: VMBook.colPubdate)
             obj.setValue(vm.publisher, forKey: VMBook.colPublisher)
             obj.setValue(vm.summary, forKey: VMBook.colSummary)
             obj.setValue(vm.title, forKey: VMBook.colTitle)
            app.saveContext()
            
            }catch {
                 throw DataError.entityExistyError("更新图书失败")
                
            }
    }
    func delete(id: UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do{
            let result = try context.fetch(fetch)
            for  b in result{
                context.delete(b as! NSManagedObject)
                
        }
            app.saveContext()
        }catch{
            throw DataError.entityExistyError("删除图书失败")

        }

    }
    
}
