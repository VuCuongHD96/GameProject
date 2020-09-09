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

class HistoryViewController: UIViewController {
    
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
                if let u = User(user: user) {
                    myScore.append(u)
                }
            }
            self.arrScore = myScore
            self.tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableview.dataSource = self
        tableview.register(UINib(nibName: Constant.historyCell, bundle: nil), forCellReuseIdentifier: Constant.cellIndentifier)
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIndentifier, for: indexPath) as! HistoryTableViewCell
        let score = arrScore[indexPath.row]
        cell.setContent(data: score, i: indexPath.row)
        return cell
    }
}
