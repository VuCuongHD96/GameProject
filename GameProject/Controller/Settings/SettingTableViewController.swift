//
//  SettingTableViewController.swift
//  GameProject
//
//  Created by KIMOCHI on 10/14/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable
import GoogleSignIn

final class SettingTableViewController: UITableViewController {
    
    // MARK: - Outlet
    @IBOutlet var numberQuestionButtonArray: [UIButton]!
    
    // MARK: - Properties
    var numberOfQuestion = 10
    typealias Handler = (Int) -> Void
    var passData: Handler?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - View
    private func setupView() {
        tableView.isScrollEnabled = false
    }

    // MARK: - Action
    @IBAction func choiseNumberOfQuestion(_ sender: UIButton) {
        switch sender.tag {
        case 0: numberOfQuestion = 10
        case 1: numberOfQuestion = 20
        case 2: numberOfQuestion = 30
        case 3: numberOfQuestion = 40
        default:
            break
        }
        numberQuestionButtonArray.forEach {
            $0.backgroundColor = nil
        }
        sender.backgroundColor = .systemGreen
    }
    
    @IBAction func saveAction(_ sender: Any) {
        passData?(numberOfQuestion)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SettingTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.settings
}
