//
//  MyUIView.swift
//  Weather
//
//  Created by 罗忠金 on 30/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit

@IBDesignable class MyUIView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
