//
//  AudioKit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 11/3/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

import Foundation

func akp(_ num: Float)->AKConstant {
    return AKConstant(value: num as NSNumber)
}

func akpi(_ num: Int)->AKConstant {
    return AKConstant(value: num as NSNumber)
}

extension Int {
    var ak: AKConstant {return AKConstant(value: self as NSNumber)}
}
extension Float {
    var ak: AKConstant {return AKConstant(value: self as NSNumber)}
}
extension Double {
    var ak: AKConstant {return AKConstant(value: self as NSNumber)}
}

extension AKMultipleInputMathOperation {
    convenience init(inputs: AKParameter...) {
        self.init()
        self.inputs = inputs
    }
}
