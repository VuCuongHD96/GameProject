//
//  CategoryCell.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

final class CategoryCell: UITableViewCell {

    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(data: String) {
        categoryLabel.text = data
        categoryImage.image = UIImage(named: data)
    }
}
