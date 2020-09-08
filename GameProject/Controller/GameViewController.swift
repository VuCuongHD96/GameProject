//
//  GameViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//
import UIKit
import FirebaseDatabase

final class GameViewController: UIViewController {
    
    //  MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var submitButton: UIButton!
    
    //  MARK: - Properties
    struct Constant {
        static let numberOfRowInSection = 4
        static let cellIndentifier = "AnswerTableViewCell"
        static let submitButtonRadius: CGFloat = 10
    }
    var category = ""
    var dataSnapShot = DataSnapshot()
    var questionArray = [Question]()
    var timeCouting = 10
    var timerCount: Timer!
    var clockBarButtonItem = UIBarButtonItem()
    var timeBarButtonItem = UIBarButtonItem()
    var answerDict = [Int : AnswerTableViewCell]()
    var examMode = ExamMode.see
    
    //  MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
        checkMode()
    }
    
    //  MARK: - Setup Data
    private func setupData() {
        navigationItem.title = category
        tableView.dataSource = self
        tableView.delegate = self
        let nibName = UINib(nibName: Constant.cellIndentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: Constant.cellIndentifier)
        for case let child as DataSnapshot in dataSnapShot.children {
            guard let dict = child.value as? [String : Any] else {
                return
            }
            let question = Question(dict)
            questionArray.append(question)
        }
    }
    
    //  MARK: - Setup View
    private func setupViews() {
        clockBarButtonItem = UIBarButtonItem(image: UIImage(named: "clock")?.withRenderingMode(.alwaysOriginal),
                                             style: .done, target: nil, action: nil)
        submitButton.layer.cornerRadius = Constant.submitButtonRadius
    }
    
    private func checkMode() {
        switch examMode {
        case .exam:
            timeBarButtonItem = UIBarButtonItem(title: "Time Left", style: .done, target: nil, action: nil)
            navigationItem.rightBarButtonItems = [timeBarButtonItem, clockBarButtonItem]
            setupTime()
        case .see:
            tableView.allowsSelection = false
            submitButton.isHidden = true
        }
    }
    
    private func setupTime() {
        timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.timeBarButtonItem = UIBarButtonItem(title: String(self.timeCouting), style: .done, target: nil, action: nil)
            self.navigationItem.rightBarButtonItems = [self.timeBarButtonItem, self.clockBarButtonItem]
            self.timeCouting -= 1
            if self.timeCouting == -1 {
                self.timerCount.invalidate()
                self.submitAction((Any).self)
                self.tableView.allowsSelection = false
            }
        }
    }
    
    //  MARK: - Action
    @IBAction func submitAction(_ sender: Any) {
        let result = questionArray.filter {
            $0.chosenCorrectAnswer == true
        }
        let score = result.count
        let alert = UIAlertController(title: "Kết quả", message: "Điểm của bạn là \(score)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        timerCount.invalidate()
        tableView.allowsSelection = false
    }
}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let question = questionArray[section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIndentifier) as? AnswerTableViewCell else {
            return UITableViewCell()
        }
        cell.setContent(data: question, for: row)
        if answerDict[section] == cell {
            cell.showCheckImage()
        } else {
            cell.invisibleCheckImage()
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Câu \(section + 1): " + questionArray[section].question
    }
}

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell else {
            return
        }
        let section = indexPath.section
        if answerDict.keys.contains(section) {
            answerDict[section]?.hideCheckImage()
        }
        cell.showCheckImage()
        answerDict[section] = cell
        let row = indexPath.row
        let trueAnswer = questionArray[section].answer
        if row == trueAnswer {
            questionArray[section].chosenCorrectAnswer = true
        } else {
            questionArray[section].chosenCorrectAnswer = false
        }
    }
}
