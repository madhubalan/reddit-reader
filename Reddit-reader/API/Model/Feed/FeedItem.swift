//
//  FeedItem.swift
//  Reddit-reader
//
//  Created by Madhu on 19/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import Foundation

struct FeedItem: Codable {
    
    let title : String?
    let url : String?
    let author : String?
    let score : Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case title
        case url
        case author
        case score
        
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        title = try data.decode(String.self, forKey: .title)
        url = try data.decode(String.self, forKey: .url)
        author = try data.decode(String.self, forKey: .author)
        score = try data.decode(Int.self, forKey: .score)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try data.encode(title, forKey: .title)
        try data.encode(url, forKey: .url)
        try data.encode(author, forKey: .author)
        try data.encode(score, forKey: .score)
        
    }

}
