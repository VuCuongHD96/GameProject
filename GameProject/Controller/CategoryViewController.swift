//
//  CategoryViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import FirebaseDatabase

final class CategoryViewController: UIViewController {
    
    //  MARK:   - Properties
    var ref: DatabaseReference!
    
    //  MARK:   - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    //  MARK:   - Setup Data
    private func fetchData() {
        ref = Database.database().reference()
        ref.child("1iaMdC7zOZDlle8jkCxed-N5fegvGdNT1stzZphOcV6s")//.child("LichSu")
            .observeSingleEvent(of: .value) { (snapshot) in
                let postDict = snapshot.value as? [String : Any] ?? [:]
                print(postDict.keys)
        }
    }
}
