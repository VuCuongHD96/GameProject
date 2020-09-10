//
//  User.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/9/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

struct User {
    var category: String
    var email = ""
    var resultMess = ""
    var resultCase: Result!
    var score: Int
    var numberOfQuestion = 1
    var isGiveUp = false
    
    init(dict: [String : Any]) {
        self.resultMess = dict["result"] as? String ?? ""
        self.category = dict["category"] as? String ?? ""
        self.score = dict["score"] as? Int ?? 0
        self.numberOfQuestion = dict["numberOfQuestion"] as? Int ?? 0
    }
    
    init(score: Int, category: String, email: String, numberOfQuestion: Int, isGiveUp: Bool) {
        self.score = score
        self.numberOfQuestion = numberOfQuestion
        self.category = category
        self.isGiveUp = isGiveUp
        self.email = email
        checkEmail()
        let resultNumber = Float(score) / Float(numberOfQuestion) * 100
        caculateResult(resultNumber: resultNumber)
    }
    
    private mutating func caculateResult(resultNumber: Float) {
        switch resultNumber {
        case 0 where isGiveUp == true:
            resultCase = Result.giveUp
            resultMess = "Give Up"
        case resultNumber where resultNumber >= 50:
            resultCase = Result.pass
            resultMess = "Pass"
        default:
            resultCase = Result.lose
            resultMess = "Lose"
        }
    }
    
    private mutating func checkEmail() {
        Firebase.prohibitArray.forEach {
            print($0)
            email = email.replacingOccurrences(of: $0, with: "", options: .literal, range: nil)
        }
    }
}
