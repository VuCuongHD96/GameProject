//
//  CategoryViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn

final class CategoryViewController: UIViewController {
    
    //  MARK:   - Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    //  MARK:   - Properties
    struct Constant {
        static let cellID = "categoryCell"
        static let navigationTitle = "Category"
    }
    var ref: DatabaseReference!
    var categoryArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var dataSnapshotArray = [DataSnapshot]()
    
    //  MARK:   - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    
    //  MARK:   - Setup Data
    private func setupData() {
        tableView.dataSource = self
        tableView.delegate = self
        ref = Database.database().reference()
        ref.child(FirebaseChild.childKey)
            .observeSingleEvent(of: .value) { (snapshot) in
                let categoryDict = snapshot.value as? [String : Any] ?? [:]
                self.categoryArray = Array(categoryDict.keys)
                for case let childOne as DataSnapshot in snapshot.children {
                    self.dataSnapshotArray.append(childOne)
                }
        }
    }
    
    //  MARK:   - Setup Views
    private func setupViews() {
        navigationItem.title = Constant.navigationTitle
        let logoutImage = UIBarButtonItem(image: UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal),
                                          style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = logoutImage
    }
    
    @objc private func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellID) else {
            return UITableViewCell()
        }
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category
        cell.imageView?.image = UIImage(named: category)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath)
        guard let gameScreen = storyboard?.instantiateViewController(identifier: "gameScreen") as? GameViewController else {
            return
        }
        gameScreen.category = categoryArray[indexPath.row]
        gameScreen.dataSnapShot = dataSnapshotArray[indexPath.row]
        navigationController?.pushViewController(gameScreen, animated: true)
    }
}
