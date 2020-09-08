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
        static let cellID = "CategoryCell"
        static let navigationTitle = "Category"
        static let cellHeight: CGFloat = 200
    }
    var ref: DatabaseReference!
    var categoryArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var dataSnapshotArray = [DataSnapshot]()
    var examMode = ExamMode.see
    var modeButton = UIBarButtonItem()
    var modeImage = UIBarButtonItem()
    
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
        let nibName = UINib(nibName: Constant.cellID, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: Constant.cellID)
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
                                          style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutImage
        navigationItem.leftBarButtonItem = logoutImage
        modeButton = UIBarButtonItem(title: "See", style: .done, target: self, action: #selector(changeMode))
        modeImage = UIBarButtonItem(image: UIImage(named: "eye")?.withRenderingMode(.alwaysOriginal),
                                        style: .done, target: self, action: #selector(changeMode))
        navigationItem.rightBarButtonItems = [modeButton, modeImage]
    }
    
    @objc private func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeMode() {
        switch examMode {
        case .exam:
            examMode = .see
        case .see:
            examMode = .exam
        }
        let rightButtonBars = examMode.getRightButtonBars()
        modeButton = UIBarButtonItem(title: rightButtonBars.title, style: .done, target: self, action: #selector(changeMode))
        modeImage = UIBarButtonItem(image: UIImage(named: rightButtonBars.image)?.withRenderingMode(.alwaysOriginal),
                                        style: .done, target: self, action: #selector(changeMode))
        navigationItem.rightBarButtonItems = [modeButton, modeImage]
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellID) as? CategoryCell else {
            return UITableViewCell()
        }
        let category = categoryArray[indexPath.row]
        cell.setContent(data: category)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gameScreen = storyboard?.instantiateViewController(identifier: "gameScreen") as? GameViewController else {
            return
        }
        gameScreen.category = categoryArray[indexPath.row]
        gameScreen.dataSnapShot = dataSnapshotArray[indexPath.row]
        gameScreen.examMode = examMode
        navigationController?.pushViewController(gameScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.cellHeight
    }
}
