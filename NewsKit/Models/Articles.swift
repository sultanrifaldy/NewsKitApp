//
//  Articles.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 06/05/23.
//

import Foundation

struct Articles: Decodable {
    let author: String
    let url: String
    let source: String
    let title: String
    let description: String
    let image: String
    let date: String
    
    
    enum CodingKeys: String, CodingKey {
        case author
        case url
        case source
        case title
        case description
        case image
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
    }
    
    init(author: String, url: String, source: String, title: String, description: String, image: String, date: String) {
        self.url = url
        self.author = author
        self.date = date
        self.source = source
        self.image = image
        self.title = title
        self.description = description
    }
}
