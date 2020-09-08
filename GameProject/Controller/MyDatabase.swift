//
//  MyDatabase.swift
//  GameProject
//
//  Created by Phan Minh Thang on 9/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import FirebaseDatabase
class MyDatabase {
    static let ref = Database.database().reference()
    static let user = UserDefaults.standard
}
