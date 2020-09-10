//
//  HistoryTableViewCell.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/9/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var numberOfQuestion: UILabel!
    @IBOutlet private weak var resultlabel: UILabel!
    @IBOutlet private weak var userNameStackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        invisibleUserStackView()
        nameLabel.text = "Tên người chơi"
    }
    
    func hideUserStackView() {
        UIView.animate(withDuration: 0.5) {
            self.userNameStackView.isHidden = true
        }
    }
    
    func showUserStackView() {
        UIView.animate(withDuration: 0.5) {
            self.userNameStackView.isHidden = false
        }
    }
    
    private func invisibleUserStackView() {
        userNameStackView.isHidden = true
    }
    
    // MARK: - Setup Data
    func setContent(data: User) {
        nameLabel.text = data.email
        categoryImageView.image = UIImage(named: data.category)
        categoryLabel.text = "Category: \(data.category)"
        scoreLabel.text = "Score: \(data.score)"
        numberOfQuestion.text = "Question: \(data.numberOfQuestion)"
        resultlabel.text = "Result: \(data.resultMess)"
    }
}
