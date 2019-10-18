//
//  VMBook.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
class VMBook:NSObject,DataViewModelDelegate{
    var author: String?
    var authorintro: String?
    var categoryld: UUID?
    var id: UUID
    var image: String?
    var isbn10: String?
    var isbn13: String?
    var pages: Int32?
    var price: Float?
    var pubdate: String?
    var publisher: String?
    var summary: String?
    var title: String?
    var binding: String?
   
    static let entityName = "Book"
    static let colId = "id"
    static let colAuthor = "author"
    static let colAuthorintro = "authorintro"
    static let colCategoryld = "categoryld"
    static let colImage = "image"
    static let colIsbn10 = "isbn10"
    static let colIsbn13 = "isbn13"
    static let colPages = "pages"
    static let colPrice = "price"
    static let colPubdate = "pubdate"
    static let colPublisher = "publisher"
    static let colSummary = "summary"
    static let colTitle = "title"
    static let colBinding = "binding"
    
    func entiyPairs() -> Dictionary<String, Any?> {
       var dic: Dictionary<String,Any?> = Dictionary<String,Any?>()
        dic[VMBook.colId] = id
        dic[VMBook.colAuthor] = author
        dic[VMBook.colAuthorintro] = authorintro
        dic[VMBook.colCategoryld] = categoryld
        dic[VMBook.colImage] = image
        dic[VMBook.colIsbn10] = isbn10
        dic[VMBook.colIsbn13] = isbn13
        dic[VMBook.colPages] = pages
        dic[VMBook.colPrice] = price
        dic[VMBook.colPubdate] = pubdate
        dic[VMBook.colPublisher] = publisher
        dic[VMBook.colSummary] = summary
        dic[VMBook.colTitle] = title
        dic[VMBook.colBinding] = binding
        return dic
        
    }
    func packageSelf(result: NSFetchRequestResult){
        let book = result as! Book
        id = book.id!
        author = book.author
        authorintro = book.authorintro
        categoryld = book.categoryld
        image = book.image
        isbn10 = book.isbn10
        isbn13 = book.isbn13
        pages = book.pages
        price = book.price
        pubdate = book.pubdate
        publisher = book.publisher
        summary = book.summary
        title = book.title
        binding = book.binding
        
    }
    
    override init(){
        id=UUID()
    }
    
    
}
