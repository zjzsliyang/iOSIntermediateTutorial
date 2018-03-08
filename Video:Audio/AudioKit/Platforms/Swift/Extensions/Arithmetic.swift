//
//  Arithmetic.swift
//  AudioKit
//
//  Created by Ales Tsurko on 18.03.15.
//  Copyright (c) 2015 Ales Tsurko. All rights reserved.
//

// Converts midi note number to ratio (speed)
extension Float {
    var midiratio: Float {return pow(2, self * 0.083333333333)}
}

func + (left: AKParameter, right: AKParameter) -> AKParameter {
    return left.plus(right)
}

func + (left: AKControl, right: AKControl) -> AKControl {
    return left.plus(right)
}

func + (left: AKConstant, right: AKConstant) -> AKConstant {
    return left.plus(right)
}

func - (left: AKParameter, right: AKParameter) -> AKParameter {
    return left.minus(right)
}

func - (left: AKControl, right: AKControl) -> AKControl {
    return left.minus(right)
}

func - (left: AKConstant, right: AKConstant) -> AKConstant {
    return left.minus(right)
}

func * (left: AKParameter, right: AKParameter) -> AKParameter {
    return left.scaled(by: right)
}

func * (left: AKControl, right: AKControl) -> AKControl {
    return left.scaled(by: right)
}

func * (left: AKConstant, right: AKConstant) -> AKConstant {
    return left.scaled(by: right)
}

func / (left: AKParameter, right: AKParameter) -> AKParameter {
    return left.divided(by: right)
}

func / (left: AKControl, right: AKControl) -> AKControl {
    return left.divided(by: right)
}

func / (left: AKConstant, right: AKConstant) -> AKConstant {
    return left.divided(by: right)
}
