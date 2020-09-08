//
//  HistoryViewController.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct User {
    var result: String
    var score: Int
    var category: String
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var ref = Database.database().reference()
    var arrScore = [User]() {
        didSet {
            tableview.reloadData()
        }
    }
    func getData() {
        var myScore = [User]()
        ref.child("Users").child("hoang").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                
                guard let user = child.value as? [String : Any] else {
                    return
                }
                    let category = user["category"] as! String
                    let result = user["result"] as! String
                    let score = user["score"] as! Int
                    let u = User(result: result, score: score, category: category)
                    myScore.append(u)
            }
            self.arrScore = myScore
            self.tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ScoreTableViewCell
        cell.lblResult.text = arrScore[indexPath.row].result
        cell.lblScore.text = String(arrScore[indexPath.row].score)
        cell.lblCategory.text = arrScore[indexPath.row].category
        cell.lblSTT.text = String(indexPath.row + 1)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultCell")
        
        
        // Do any additional setup after loading the view.
    }
}
