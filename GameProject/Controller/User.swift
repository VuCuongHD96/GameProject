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
    
    init(user: [String : Any]) {
        self.category = user["category"] as! String
        self.score = user["score"] as! Int
        self.result = user["result"] as! String
    }
}
