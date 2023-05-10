//
//  ApiService.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 07/05/23.
//

import Foundation
import Alamofire

class ApiService {
    static let shared: ApiService = ApiService()
    private init() {}
    
    private let API = "https://api.lil.software/news"
    
    
    func loadNews(completion: @escaping(Result<[Articles],Error>)-> Void) {
        let urlString = API
        
        AF.request(urlString, method: HTTPMethod.get)
            .validate()
            .responseDecodable(of: NewsRespons.self) { response in
                switch response.result {
                case .success(let newsArticle):
                    completion(.success(newsArticle.articles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
