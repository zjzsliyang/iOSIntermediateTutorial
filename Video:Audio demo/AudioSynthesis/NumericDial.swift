//
//  NumericDial.swift
//  NumericDial
//
//  Created by Simon Gladman on 05/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class NumericDial: UIControl
{
    let minimumValue = 0.0
    let maximumValue = 1.0
    let trackLayer = NumericDialTrack()
    let background = NumericDialBackground()
    let label = UILabel();
    let titleLabel = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        background.contentsScale = UIScreen.main.scale
        layer.addSublayer(background)
        
        trackLayer.numericDial = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        self.addSubview(label)
        
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.blue
        
        self.addSubview(titleLabel)
        
        drawTrack()
    }
    
    required init(coder: NSCoder)
    {
        super.init(coder: coder)!
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
    {
        setCurrentValueFromLocation(touch.location(in: self))
        
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
    {
        setCurrentValueFromLocation(touch.location(in: self))

        return true
    }
    
    fileprivate func setCurrentValueFromLocation(_ location : CGPoint)
    {
        let angle = atan2(location.x - (frame.width / 2), location.y - (frame.height / 2)) * 180/CGFloat(M_PI)
        let distance = hypot(location.x - (frame.width / 2), location.y - (frame.height / 2))
        
        if distance > (frame.width / 2.0 * 0.6) && distance < frame.width / 2 && ((angle < -45 && angle > -180) || (angle < 180 && angle > 45))
        {
            currentValue = Float(getValueFromAngle(angle))
        }
        else if distance > (frame.width / 2.0 * 0.6) && distance < frame.width / 2 && (angle > -45 && angle < -35)
        {
            currentValue = 0
        }
        else if distance > (frame.width / 2.0 * 0.6) && distance < frame.width / 2 && (angle < 45 && angle > 35)
        {
            currentValue = 1
        }
    }
    
    var currentValue : Float = 0.0
    {
        didSet
        {
            currentValue = currentValue < 0 ? 0 : currentValue
            currentValue = currentValue > 1 ? 1 : currentValue
        
            sendActions(for: .valueChanged)
            drawTrack()
        }
    }

    var labelFunction : (Float) -> String = NumericDial.defaultLabelFunction
    {
        didSet
        {
            label.text = labelFunction(currentValue)
        }
    }

    var title : String = ""
    {
        didSet
        {
            titleLabel.text = title
        }
    }
    
    func drawTrack()
    {
        label.frame = bounds.insetBy(dx: 0, dy: 0)
        label.text = labelFunction(currentValue)
        
        trackLayer.frame = bounds.insetBy(dx: 0, dy: 0)
        trackLayer.drawValueCurve()
    }
    
    override var frame: CGRect
    {
        didSet
        {
            background.frame = bounds.insetBy(dx: 0, dy: 0)
            background.drawBackgroundCurve()
            
            titleLabel.frame = CGRect(x: 0, y: frame.height - 23, width: frame.width, height: 20)
            
            drawTrack()
        }
    }
    
    final func getValueFromAngle(_ value : CGFloat) -> CGFloat
    {
        var returnNumber : CGFloat;
        
        if (value < 0)
        {
            returnNumber = (abs(value + 45) / 135) / 2;
        }
        else
        {
            returnNumber = 0.5 + (((181 - value) / 135) / 2) ;
        }
        
        return returnNumber;
    }
    
    class func defaultLabelFunction(_ value : Float) -> String
    {
        return NSString(format: "%.4f", value) as String
    }
}
