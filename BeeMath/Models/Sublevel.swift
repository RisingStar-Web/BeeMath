//
//  Sublevel.swift
//  BeeMath
//
//  Created by Денис Марков on 3/6/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import Foundation
import UIKit
fileprivate let evidenceCount = 6

class Sublevel {
    var rightAnswer: Int
    var evidences: [Evidence] = []
    
    init(left: Int, right: Int) {
        let que = DispatchQueue.init(label: "BeeMathLevelInit", qos: .userInteractive)
        rightAnswer = left * right
        var operands = Constants.numbers
        var rightOperands: [Int] = []
        que.sync {
            for _ in 0..<evidenceCount {
                let rightIndex = Int.random(in: 0..<operands.count)
                let rightOperand = operands[rightIndex]
                rightOperands.append(rightOperand)
                operands.remove(at: rightIndex)
            }
            if !rightOperands.contains(right) {
                let index = Int.random(in: 0..<rightOperands.count)
                rightOperands[index] = right
            }
            for rightOperand in rightOperands {
                evidences.append(Evidence(leftOperand: left, rightOperand: rightOperand))
            }
        }
    }
}
