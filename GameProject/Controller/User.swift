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
    init(result: String, category: String, score: Int) {
        self.result = result
        self.score = score
        self.category = category
    }
}
