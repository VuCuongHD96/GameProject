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
    @IBOutlet private weak var checkImage: UIImageView!
    @IBOutlet private weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hideCheckImage()
    }
    
    //  MARK: - Setup Data
    func setContent(data: Question, row: Int) {
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
    func hideCheckImage() {
        UIView.animate(withDuration: 0.5) {
            self.checkImage.transform = .init(translationX: -50, y: 0)
        }
    }
    
    func showCheckImage() {
        UIView.animate(withDuration: 0.5) {
            self.checkImage.transform = .identity
        }
    }
}
