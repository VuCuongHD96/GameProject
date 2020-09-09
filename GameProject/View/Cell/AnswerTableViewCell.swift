//
//  AnswerTableViewCell.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/6/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    //  MARK: - Outlet
    @IBOutlet private weak var selectedIcon: UIImageView!
    @IBOutlet private weak var answerLabel: UILabel!
    
    //  MARK: - Properties
    struct Constant {
        static let animationTime = 0.3
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        invisibleCheckImage()
        hideCheckImage()
        selectionStyle = .none
    }
    
    //  MARK: - Setup Data
    func setContent(data: Question, for row: Int) {
        var answer = ""
        switch row {
        case 0:
            answer = "A: " + data.a
        case 1:
            answer = "B: " + data.b
        case 2:
            answer = "C: " + data.c
        case 3:
            answer = "D: " + data.d
        default:
            print("Chọn sai")
        }
        answerLabel.text = answer
    }
    
    //  MARK: - Setup View
    func invisibleCheckImage() {
        selectedIcon.isHidden = true
    }
    
    func hideCheckImage() {
        UIView.animate(withDuration: Constant.animationTime) {
            self.selectedIcon.transform = .init(translationX: -50, y: 0)
        }
    }
    
    func showCheckImage() {
        UIView.animate(withDuration: Constant.animationTime) {
            self.selectedIcon.isHidden = false
            self.selectedIcon.transform = .identity
        }
    }
}
