//
//  HistoryTableViewCell.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/9/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var lblSTT: UILabel!
    
    @IBOutlet private weak var lblCategory: UILabel!
    
    @IBOutlet private weak var lblScore: UILabel!
    
    @IBOutlet private weak var lblResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(data: User, i: Int) {
        lblResult.text = data.result
        lblScore.text = String(data.score)
        lblCategory.text = data.category
        lblSTT.text = String(i+1)
    }
}
