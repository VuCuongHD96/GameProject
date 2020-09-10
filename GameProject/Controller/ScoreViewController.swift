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
    
    // MARK: - Outlet
    @IBOutlet private weak var resultImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    struct Constant {
        static let childKey = "Users"
    }
    var ref = Database.database().reference()
    var timer = Timer()
    var timeNext = 2
    var userName: String = "thang"
    var category: String = "toan"
    var result: String = "pass"
    var score = 0
    var email = "thang"
    var userArray = [User]() {
        didSet {
            tableView.reloadData()
        }
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
                if let u = User(user: user) {
                    myUser.append(u)
                }
            }
            self.ref.child("Users").child(self.userName).child("\(myUser.count + 1)").setValue(["category": self.category, "result": self.result, "score": self.score])
        }
    }
    
    func nextVC() {
        guard let historyVC = storyboard?.instantiateViewController(identifier: "History") as? HistoryViewController else {
            return
        }
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        timeNext -= 1
        if (timeNext == 0) {
            timer.invalidate()
            nextVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        tableView.dataSource = self
        switch score {
        case 0:
            resultImageView.image = UIImage(named: "giveup")
        case score:
            resultImageView.image = UIImage(named: "win")
        default:
            print("chọn sai")
        }
    }
    
    // MARK: - Setup Data
    private func setupData() {
        fetchData()
    }
    
    private func fetchData() {
        ref.child("Users").child("thang")
            .observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let userDict = child.value as? [String : Any] else {
                    return
                }
                if let user = User(user: userDict) {
                    self.userArray.append(user)
                }
            }
        }
    }

    // MARK: - Action
    @IBAction func playAgain(_ sender: Any) {
        guard let categoryScreen = storyboard?.instantiateViewController(identifier: "categoryScreen") else {
            return
        }
        navigationController?.popToViewController(categoryScreen, animated: true)
    }
}

extension ScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = userArray[indexPath.row].category
        return cell
    }
}
