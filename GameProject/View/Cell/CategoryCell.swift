//
//  CategoryCell.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

import UIKit

final class CategoryCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    // MARK: - Properties
    struct Constant {
        static let categoryImageRadius: CGFloat = 10
    }
    
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
}
