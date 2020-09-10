//
//  User.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/9/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

struct User {
    var result: String
    var score: Int
    var category: String
    
    init?(user: [String : Any]) {
        guard let category = user["category"] as? String else { return nil }
        self.category = category
        guard let score = user["score"] as? Int else { return nil }
        self.score = score
        guard let result = user["result"] as? String else { return nil }
        self.result = result
    }
}
