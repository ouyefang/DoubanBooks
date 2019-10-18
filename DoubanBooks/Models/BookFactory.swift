//
//  BookFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/17.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation
final class BookFactory{
    var repository: Repository<VMBook>
    private static var instance: BookFactory?
    private  init(_ app:AppDelegate) {
        repository = Repository<VMBook>(app)
  }
    
    
    static func getInstance(_ app: AppDelegate)->BookFactory{
        if let obj=instance{
            return obj
        }else{
            let token = "net.lzzy.factory.book"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
        
    }
    
    func getBooksOf(category id: UUID) throws ->[VMBook] {
        return try
            repository.getExplicitlyBy([VMBook.colCategoryld], keyword: id.uuidString)
    }
    
    
    func getBook(id: UUID) throws -> VMBook? {
        let books = try repository.getExplicitlyBy([VMBook.colId], keyword: id.uuidString)
        if books.count > 0{
            return books[0]
        }
        return nil
    }
    
    
    func isBookExists(book: VMBook) throws-> Bool {
        var match10 = false
        var match13 = false
        if let isbn10 = book.isbn10 {
            if isbn10.count > 0 {
                match10 = try repository.isEntityExists([VMBook.colIsbn10], keyword: isbn10)
            }
        }
        if let isbn13 = book.isbn13{
            if isbn13.count > 0 {
            match13 = try repository.isEntityExists([VMBook.colIsbn13], keyword: isbn13)
        }
    }
        return  match13 || match10
    
}
    func searchbooks(keyword: String) throws -> [VMBook] {
        let cols = [VMBook.colIsbn13,VMBook.colTitle,VMBook.colAuthor,VMBook.colPublisher,VMBook.colSummary]
        let books = try repository.getBy(cols, keyword: keyword)
        return books
    }
    func addBook(book: VMBook) throws-> (Bool,String?){
        do{
            if try isBookExists(book: book){
                return (false,"图书已存在")
            }
            repository.insert(vm: book)
            return(true,nil)
        }catch DataError.entityExistyError(let info){
            
                return (false,info)
        }catch{
                return (false,error.localizedDescription)
        }
    }
    func removeBook(id:UUID) -> (Bool,String?) {
        do{
            try repository.delete(id: id)
            return(true,nil)
        }catch DataError.deleteExtityError(let info){
            
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
            
        }

    
    }

}


