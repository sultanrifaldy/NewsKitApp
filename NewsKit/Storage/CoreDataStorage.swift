//
//  CoreDataStorage.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 10/05/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorage {
    static let shared: CoreDataStorage = CoreDataStorage()

    private init () {
        printCoreDataDBPath()
    }

    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.viewContext
    }()


    func printCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

         print("Core Data DB Path :: \(path ?? "Not found")")
    }

    func addReadingList(articles: Articles) {
        let articlesData: ArticlesData

        let fetchRequest = ArticlesData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author = \(articles.author)")
        if let data = try? context.fetch(fetchRequest).first {
            articlesData = data
        } else {
            articlesData = ArticlesData(context: context)
        }

        articlesData.url = articles.url
        articlesData.source = articles.source
        articlesData.image = articles.image
        articlesData.title = articles.title
        articlesData.date = articles.date
        articlesData.author = articles.author
        articlesData.descriptionarticle = articlesData.description

        NotificationCenter.default.post(name: .addReadingList, object: nil)

        try? context.save()

    }

    func getReadingList() -> [Articles] {
        let fetchRequest = ArticlesData.fetchRequest()
        let datas = (try? context.fetch(fetchRequest)) ?? []
        let newsList = datas.compactMap { newsData in
            return newsData.dto
        }
        return newsList
    }

    func deleteReadingList(articles: Articles) {

        let fetchRequest = ArticlesData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author = \(articles.author)")
        if let data = try? context.fetch(fetchRequest).first {
            context.delete(data)

            try? context.save()
        }
    }
    
    func isAddedToReadingList(articles: Articles) -> Bool {
        let fetchRequest = ArticlesData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author = \(articles.author)")
        if (try? context.fetch(fetchRequest).first) != nil {
            return true
        } else {
            return false
        }
        
    }

}

extension ArticlesData{
    var dto: Articles{
        let news = Articles(author: self.author ?? "",
                            url: self.url ?? "",
                            source: self.source ?? "",
                            title: self.title ?? "",
                            description: self.description ,
                            image: self.image ?? "",
                            date: self.date ?? ""
        )
        return news
    }
}
