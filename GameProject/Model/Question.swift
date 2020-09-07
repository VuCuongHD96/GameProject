
//
//  Question.swift
//  GameProject
//
//  Created by KIMOCHI on 9/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

struct Question {
    var id: Int
    var a: String
    var b: String
    var c: String
    var d: String
    var question: String
    var answer: Int
    var chosenCorrectAnswer = false
    
    init(_ dict: [String : Any]) {
        self.question = dict["Question"] as? String ?? ""
        self.answer = dict["Answer"] as? Int ?? 0
        self.id = dict["id"] as? Int ?? 0
        self.a = dict["A"] as? String ?? ""
        self.b = dict["B"] as? String ?? ""
        self.c = dict["C"] as? String ?? ""
        self.d = dict["D"] as? String ?? ""
    }
}
