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
import Reusable
import Then

final class CategoryViewController: UIViewController {
    
    //  MARK:   - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
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
            activityIndicatorView.isHidden = true
            tableView.reloadData()
        }
    }
    var dataSnapshotArray = [DataSnapshot]()
    var modeButton = UIBarButtonItem()
    var modeImage = UIBarButtonItem()
    var numberOfQuestion = 20
    var timeToPlay = 10
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
        refreshControl.addTarget(self, action: #selector(refreshCategoryData), for: .allEvents)
        tableView.do {
            $0.refreshControl = refreshControl
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CategoryCell.self)
        }
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
        let settingImage = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingImage, style: .done, target: self, action: #selector(gotoSettingScreen))
    }
    
    @objc private func gotoSettingScreen() {
        let settingScreen = SettingTableViewController.instantiate()
        settingScreen.passData = {
            self.numberOfQuestion = $0
//            self.timeToPlay = $1
        }
        navigationController?.pushViewController(settingScreen, animated: true)
    }
    
    @objc private func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        navigationController?.popViewController(animated: true)
    }
    
    private func gotoGameScreen(_ row: Int, mode: ExamMode) {
        let gameScreen = GameViewController.instantiate()
        gameScreen.do {
            $0.categoryName = categoryArray[row]
            $0.dataSnapShot = dataSnapshotArray[row]
            $0.examMode = mode
            $0.timeCouting = timeToPlay
            $0.numberOfQuestion = numberOfQuestion
        }
        navigationController?.pushViewController(gameScreen, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
        cell.choiseExamMode = { [weak self] in
            guard let self = self else { return }
            self.gotoGameScreen(indexPath.row, mode: $0)
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
