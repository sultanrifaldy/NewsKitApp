//
//  NewsResponse.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 06/05/23.
//

import Foundation

struct NewsRespons: Decodable {
    let articles: [Articles]
    
    enum CodingKeys: String, CodingKey {
        case articles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.articles = try container.decodeIfPresent([Articles].self, forKey: .articles) ?? []
    }
}
