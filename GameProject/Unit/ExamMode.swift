//
//  ExamMode.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/8/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation

enum ExamMode {
    case see
    case exam
    
    func getRightButtonBars() -> RightButtonBars {
        switch self {
        case .exam:
            return RightButtonBars(image: "test", title: "Exam")
        case .see:
            return RightButtonBars(image: "eye", title: "See")
        }
    }
}
