//
//  GameViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//
import UIKit
import FirebaseDatabase
import Reusable
import Then

final class GameViewController: UIViewController {
    
    //  MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var showResult: UIButton!
    @IBOutlet private weak var resultStackView: UIStackView!
    
    //  MARK: - Properties
    struct Constant {
        static let numberOfRowInSection = 4
        static let submitButtonRadius: CGFloat = 10
        static let titleHeaderFontSize: CGFloat = 15
        static let maxNumberOfQuestion = 40
    }
    var categoryName = ""
    var dataSnapShot = DataSnapshot()
    var questionArray = [Question]()
    var timeCouting = 60
    var timerCount: Timer!
    var clockBarButtonItem = UIBarButtonItem()
    var timeBarButtonItem = UIBarButtonItem()
    var answerDict = [Int : AnswerTableViewCell]()
    var examMode = ExamMode.see
    var isSubmit = false
    var isSelectedAnswer = false
    var numberOfQuestion = 0
    var timeToPlay = 0
    
    //  MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
        checkMode()
    }
    
    //  MARK: - Setup Data
    private func setupData() {
        navigationItem.title = categoryName
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: AnswerTableViewCell.self)
        }
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
        showResult.isHidden = true
        clockBarButtonItem = UIBarButtonItem(image: UIImage(named: "clock")?.withRenderingMode(.alwaysOriginal),
                                             style: .done, target: nil, action: nil)
        submitButton.layer.cornerRadius = Constant.submitButtonRadius
        let backBarButton = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal),
                                            style: .done, target: self, action: #selector(backToCategory))
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc private func backToCategory() {
        switch examMode {
        case .exam:
            quitExamAlert()
        case .see:
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func quitExamAlert() {
        timerCount.invalidate()
        let quitAlert = UIAlertController(title: "Thông báo!", message: "Kết quả bài thi này sẽ không được lưu!\nBạn có chắc chắn bỏ cuộc không?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { [weak self] (_) in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "No", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            self.setupTime()
        }
        quitAlert.addAction(noAction)
        quitAlert.addAction(yesAction)
        present(quitAlert, animated: true, completion: nil)
    }
    
    private func checkMode() {
        switch examMode {
        case .exam:
            timeBarButtonItem = UIBarButtonItem(title: "Time Left", style: .done, target: nil, action: nil)
            navigationItem.rightBarButtonItems = [timeBarButtonItem, clockBarButtonItem]
            setupTime()
            questionArray = Array(questionArray.prefix(numberOfQuestion))
        case .see:
            tableView.allowsSelection = false
            resultStackView.isHidden = true
            questionArray = Array(questionArray.prefix(Constant.maxNumberOfQuestion))
        }
    }
    
    private func setupTime() {
        timeCouting = 60
        timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.timeBarButtonItem = UIBarButtonItem(title: String(self.timeCouting), style: .done, target: nil, action: nil)
            self.navigationItem.rightBarButtonItems = [self.timeBarButtonItem, self.clockBarButtonItem]
            self.timeCouting -= 1
            if self.timeCouting == -1 {
                self.timerCount.invalidate()
                self.submitAction(self.submitButton)
                self.tableView.allowsSelection = false
            }
        }
    }
    
    private func getCell(_ indexPath: IndexPath) -> AnswerTableViewCell {
        guard let cell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell else {
            return AnswerTableViewCell()
        }
        return cell
    }
    
    //  MARK: - Action
    @IBAction func submitAction(_ sender: UIButton) {
        isSubmit = true
        tableView.reloadData()
        examMode = .see
        timerCount.invalidate()
        tableView.allowsSelection = false
        sender.isEnabled = false
        sender.backgroundColor = .gray
        timerCount.invalidate()
        UIView.animate(withDuration: 0.7, animations: {
            self.showResult.isHidden = false
        }) { _ in
            self.setupShowResultOutlet()
        }
    }
    
    private func setupShowResultOutlet() {
        timeCouting = 10
        timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timeCouting -= 1
            self.showResult.setTitle("Show Result (\(self.timeCouting))", for: .normal)
            if self.timeCouting == 0 {
                self.gotoScoreScreen()
            }
        })
    }
    
    @IBAction func showResultAction(_ sender: Any) {
        gotoScoreScreen()
    }
    
    @objc private func gotoScoreScreen() {
        let result = questionArray.filter {
            $0.chosenCorrectAnswer == true
        }
        let score = result.count
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let user = User(score: score, category: categoryName, email: email, numberOfQuestion: questionArray.count, isGiveUp: !isSelectedAnswer)
        let scoreScreen = ScoreViewController.instantiate()
        scoreScreen.user = user
        navigationController?.pushViewController(scoreScreen, animated: true)
        timerCount.invalidate()
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
        let cell: AnswerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContent(data: question, for: row)
        if question.answerSelected == row {
            cell.showCheckImage()
        } else {
            cell.invisibleCheckImage()
        }
        if isSubmit {
            if row == question.answer {
                cell.backgroundColor = .green
            } else {
                cell.backgroundColor = .white
            }
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
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = .white
            headerView.textLabel?.textColor = .red
            headerView.textLabel?.font = .systemFont(ofSize: Constant.titleHeaderFontSize)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if section != questionArray.count - 1 {
            let nextIndexPath = IndexPath(row: row, section: section + 1)
            tableView.scrollToRow(at: nextIndexPath, at: .middle, animated: true)
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell else {
            return
        }
        cell.showCheckImage()
        if answerDict.keys.contains(section) {
            answerDict[section]?.hideCheckImage()
        }
        answerDict[section] = cell
        questionArray[section].checkAnswer(answerSelected: row)
        isSelectedAnswer = true
    }
}

extension GameViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.game
}
