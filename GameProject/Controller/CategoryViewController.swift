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
        static let cellHeight: CGFloat = 250
        static let scaleTime = 0.3
        static let scaleRatio: CGFloat = 0.5
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
    private let refreshControl = UIRefreshControl()
    
    //  MARK:   - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        print("Category die")
    }
    
    //  MARK:   - Setup Data
    private func setupData() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshCategoryData), for: .allEvents)
        tableView.dataSource = self
        tableView.delegate = self
        let nibName = UINib(nibName: Constant.cellID, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: Constant.cellID)
        fetchData()
    }
    
    private func fetchData() {
        ref = Database.database().reference()
        ref.child(Firebase.childKey)
            .observeSingleEvent(of: .value) { (snapshot) in
                let categoryDict = snapshot.value as? [String : Any] ?? [:]
                self.categoryArray = Array(categoryDict.keys)
                for case let childOne as DataSnapshot in snapshot.children {
                    self.dataSnapshotArray.append(childOne)
                }
        }
    }
    
    @objc private func refreshCategoryData(_ sender: Any) {
        fetchData()
        refreshControl.endRefreshing()
    }
    
    //  MARK:   - Setup Views
    private func setupViews() {
        navigationItem.title = Constant.navigationTitle
        navigationItem.hidesBackButton = true
    }
    
    @objc private func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.popViewController(animated: true)
    }
    
    private func gotoGameScreen(_ row: Int, mode: ExamMode) {
        guard let gameScreen = storyboard?.instantiateViewController(identifier: "gameScreen") as? GameViewController else {
            return
        }
        gameScreen.category = categoryArray[row]
        gameScreen.dataSnapShot = dataSnapshotArray[row]
        gameScreen.examMode = mode
        navigationController?.pushViewController(gameScreen, animated: true)
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
        cell.choiseExamMode = { [weak self] in
            self?.gotoGameScreen(indexPath.row, mode: $0)
        }
        let category = categoryArray[indexPath.row]
        cell.setContent(data: category)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else {
            return
        }
        UIView.animate(withDuration: Constant.scaleTime) {
            cell.transform = .init(scaleX: Constant.scaleRatio, y: Constant.scaleRatio)
            UIView.animate(withDuration: Constant.scaleTime) {
                cell.transform = .identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.cellHeight
    }
}
