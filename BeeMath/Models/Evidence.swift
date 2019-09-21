//
//  Evidence.swift
//  BeeMath
//
//  Created by Денис Марков on 3/5/19.
//  Copyright © 2019 Денис Марков. All rights reserved.
//

import Foundation

class Evidence {
    var text: String
    var result: Int
    var isLeft: Bool
    var wrong = false
    
    init(leftOperand: Int, rightOperand: Int) {
        self.text = "\(leftOperand) * \(rightOperand)"
        self.result = leftOperand * rightOperand
        isLeft = rightOperand % 2 != 0
    }
}
