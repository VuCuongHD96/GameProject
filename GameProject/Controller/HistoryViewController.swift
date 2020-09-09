//
//  HistoryViewController.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/9/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var userName = "thang"
    var ref = Database.database().reference()
    struct Constant {
        static let cellIndentifier = "ResultCell"
        static let historyCell = "HistoryTableViewCell"
        static let childKey = "Users"
    }
    var arrScore = [User]() {
        didSet {
            tableview.reloadData()
        }
    }
    
    func getData() {
        var myScore = [User]()
        ref.child(Constant.childKey).child(userName).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let user = child.value as? [String : Any] else {
                    return
                }
                let category = user["category"] as! String
                let result = user["result"] as! String
                let score = user["score"] as! Int
                let u = User(result: result, category: category, score: score)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIndentifier, for: indexPath) as! HistoryTableViewCell
        let score = arrScore[indexPath.row]
        cell.setContent(data: score, i: indexPath.row)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: Constant.historyCell, bundle: nil), forCellReuseIdentifier: Constant.cellIndentifier)
    }
    
}
