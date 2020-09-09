//
//  ScoreViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase

final class ScoreViewController: UIViewController {
    
    var ref = Database.database().reference()
    var i = 0
    var timer = Timer()
    var timeNext = 2
    var userName: String = "thang"
    var category: String = "toan"
    var result: String = "pass"
    var score: Int = 120
     struct Constant {
        static let childKey = "Users"
    }
    
    @IBAction func btnHistory(_ sender: Any) {
        getData()
        runTimer()
    }
    
    func getData() {
        var myUser = [User]()
        ref.child(Constant.childKey).child(userName).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let user = child.value as? [String : Any] else {
                    return
                }
                let category = user["category"] as! String
                let result = user["result"] as! String
                let score = user["score"] as! Int
                let u = User(result: result, score: score, category: category)
                myUser.append(u)
            }
            self.i = myUser.count
            self.ref.child("Users").child(self.userName).child("\(self.i+1)").setValue(["category": self.category, "result": self.result, "score": self.score])
        }
    }
    
    func nextVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = sb.instantiateViewController(identifier: "History") as! HistoryViewController
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        timeNext -= 1
        if(timeNext == 0){
            timer.invalidate()
            nextVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
