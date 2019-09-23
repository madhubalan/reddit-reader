//
//  Feed.swift
//  Reddit-reader
//
//  Created by Madhu on 22/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import Foundation

struct Feeds: Codable {
    
    let children : [FeedItem]
    
    enum CodingKeys: String, CodingKey {
        case data
        case children
        
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        children = try data.decode([FeedItem].self, forKey: .children)
    }
    
    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        var data = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try data.encode(children, forKey: .children)
    }
    
}
