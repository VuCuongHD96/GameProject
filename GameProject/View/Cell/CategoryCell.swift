//
//  CategoryCell.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    // MARK: - Properties
    struct Constant {
        static let categoryImageRadius: CGFloat = 10
    }
    typealias handle = (ExamMode) -> ()
    var choiseExamMode: handle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        categoryImage.layer.cornerRadius = Constant.categoryImageRadius
        selectionStyle = .none
    }
    
    // MARK: - Setup Data
    func setContent(data: String) {
        categoryLabel.text = data
        categoryImage.image = UIImage(named: data)
    }
    
    // MARK: - Action
    @IBAction func choiseAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.transform = .init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                sender.transform = .identity
            }) { [weak self] (_) in
                switch sender.tag {
                case 0:
                    self?.choiseExamMode?(ExamMode.see)
                case 1:
                    self?.choiseExamMode?(ExamMode.exam)
                default:
                    print("Chọn sai")
                }
            }
        }
    }
}
