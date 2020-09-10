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

final class HistoryViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableview: UITableView!
    
    // MARK: - Properties
    struct Constant {
        static let historyCell = "HistoryTableViewCell"
        static let childKey = "Users"
    }
    var user: User!
    var ref: DatabaseReference!
    var userArray = [User]() {
        didSet {
            tableview.reloadData()
        }
    }
    var segmentIndexChange: Int! {
        didSet {
            tableview.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    // MARK: - Setup Data
    private func setupData() {
        tableview.dataSource = self
        tableview.delegate = self
        let nibName = UINib(nibName: Constant.historyCell, bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: Constant.historyCell)
        fetchData()
    }
    
    private func fetchData() {
        ref = Database.database().reference()
        ref.child(Constant.childKey).child(user.email)
            .observeSingleEvent(of: .value) { snapshot in
                for case let child as DataSnapshot in snapshot.children {
                    let userDict = child.value as? [String : Any] ?? [:]
                    let user = User(dict: userDict)
                    self.userArray.append(user)
                }
        }
    }
    
    // MARK: - Setup Data
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        segmentIndexChange = sender.selectedSegmentIndex
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.historyCell, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        let user = userArray[indexPath.row]
        cell.setContent(data: user)
        switch segmentIndexChange {
        case 0:
            cell.hideUserStackView()
        case 1:
            cell.showUserStackView()
        default:
            print("Segment sai")
        }
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
