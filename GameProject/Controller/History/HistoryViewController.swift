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
import Reusable

final class HistoryViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableview: UITableView!
    
    // MARK: - Properties
    struct Constant {
        static let historyCell = "HistoryTableViewCell"
        static let childKey = "Users"
        static let cellHeight: CGFloat = 180
    }
    var user: User!
    var ref: DatabaseReference!
    var historyArray = [User]() {
        didSet {
            listUserArray = historyArray
        }
    }
    var rankArray = [User]() 
    var listUserArray = [User]() {
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
        fetchHistoryData()
        fetchRankData()
    }
    
    private func fetchHistoryData() {
        ref = Database.database().reference()
        ref.child(Constant.childKey).child(user.email)
            .observeSingleEvent(of: .value) { snapshot in
                for case let child as DataSnapshot in snapshot.children {
                    let userDict = child.value as? [String : Any] ?? [:]
                    let user = User(dict: userDict)
                    self.historyArray.append(user)
                }
        }
    }
    
    private func fetchRankData() {
        ref.child(Constant.childKey).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                let email = child.key
                print(email)
                self.getHighestScoreFrom(email: email)
            }
        }
    }
    
    private func sortRank() -> [User] {
        return rankArray.sorted {
            $0.score > $1.score
        }
    }
    
    private func getHighestScoreFrom(email: String) {
        ref.child(Constant.childKey).child(email).queryOrdered(byChild: "score").queryLimited(toLast: 1)
            .observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                let userDict = child.value as? [String : Any] ?? [:]
                var user = User(dict: userDict)
                user.email = email
                self.rankArray.append(user)
            }
        }
    }
    
    // MARK: - Setup Data
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        segmentIndexChange = sender.selectedSegmentIndex
        switch segmentIndexChange {
        case 0:
            listUserArray = historyArray
        case 1:
            listUserArray = sortRank()
        default:
            print("Chọn sai Segment Index")
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.historyCell, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        let user = listUserArray[indexPath.row]
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
        return Constant.cellHeight
    }
}

extension HistoryViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.history
}
