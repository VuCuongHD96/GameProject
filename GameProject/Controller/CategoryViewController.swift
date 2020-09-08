//
//  CategoryViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import FirebaseDatabase

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
    
    //  MARK:   - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupViews()
    }
    
    //  MARK:   - Setup Data
    private func fetchData() {
        ref = Database.database().reference()
        ref.child(FirebaseChild.childKey)
            .observeSingleEvent(of: .value) { (snapshot) in
                let postDict = snapshot.value as? [String : Any] ?? [:]
                self.categoryArray = Array(postDict.keys)
                //print(postDict)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //  MARK:   - Setup Views
    private func setupViews() {
        navigationItem.title = Constant.navigationTitle
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
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}
