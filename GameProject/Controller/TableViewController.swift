//
//  TableViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/11/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

final class TableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var abc: UILabel!
    
    typealias handler = (String) -> ()
    var passData: handler?
    var index = 0
    var numberOfQuestionArray = ["10", "20", "30", "40"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    @IBAction func logoutAction(_ sender: Any) {
        passData?("truyền data về")
    }
    
    @IBAction func numberQuestionStepperAction(_ sender: UIStepper) {
        print(sender.value)
//        numberOfQuestDataLabel.text =
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifierCell = ""
        switch indexPath.row {
        case 0:
            identifierCell = "numberQuestCell"
        case 1:
            identifierCell = "logoutCell"
        default:
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell) else { return UITableViewCell()
        }
        return cell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
