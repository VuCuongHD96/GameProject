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
    @IBOutlet private weak var resultMessLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var backGroundImageView: UIImageView!
    
    struct Constant {
        static let childKey = "Users"
    }
    var user: User!
    var ref: DatabaseReference!
    var numericalOrder: Int! {
        didSet {
            pushDataToFireBase()
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        switch user.resultCase {
        case .giveUp:
            resultImageView.image = UIImage(named: "giveup")
            resultMessLabel.text = user.resultCase.getResultString()
        case .pass:
            resultImageView.image = UIImage(named: "RankCup")
            resultMessLabel.text = user.resultCase.getResultString()
        default:
            resultImageView.image = UIImage(named: "lose")
            resultMessLabel.text = user.resultCase.getResultString()
        }
        scoreLabel.text = String(user.score) + "/" + String(user.numberOfQuestion)
        backGroundImageView.image = UIImage(named: user.category)
        navigationItem.title = "Result"
    }
    
    // MARK: - Setup Data
    private func setupData() {
        ref = Database.database().reference()
        getNextNumericalOrder()
    }
    
    private func getNextNumericalOrder() {
        ref.child(Constant.childKey).child(user.email)
            .observeSingleEvent(of: .value) { [weak self] snapshot in
                self?.numericalOrder = Int(snapshot.childrenCount) + 1
        }
    }
    
    private func pushDataToFireBase() {
        ref.child(Constant.childKey).child(user.email).child("\(numericalOrder ?? 0)")
            .setValue(["category": user.category,
                       "score": user.score,
                       "result": user.resultMess,
                       "numberOfQuestion": user.numberOfQuestion
            ])
    }

    // MARK: - Action
    @IBAction func viewResult(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playAgain(_ sender: Any) {
        guard let categoryScreen = navigationController?.viewControllers[1] as? CategoryViewController else {
            return
        }
        navigationController?.popToViewController(categoryScreen, animated: true)
    }
    
    @IBAction func viewHistory(_ sender: Any) {
        guard let historyScreen = storyboard?.instantiateViewController(identifier: "historyScreen") as? HistoryViewController else {
            return
        }
        historyScreen.user = user
        navigationController?.pushViewController(historyScreen, animated: true)
    }
}
