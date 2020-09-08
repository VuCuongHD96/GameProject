//
//  ScoreTableViewCell.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/6/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblSTT: UILabel!
    
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var lblResult: UILabel!
   
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
