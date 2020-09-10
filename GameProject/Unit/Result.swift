//
//  Result.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/10/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

enum Result {
    case pass
    case lose
    case giveUp
    
    func getResultString() -> String {
        switch self {
        case .pass:
            return "Cograulations! You're pass."
        case .lose:
            return "Good luck next time!"
        case .giveUp:
            return "This exam is a bit difficult.\nLet try another exam!"
        }
    }
}
