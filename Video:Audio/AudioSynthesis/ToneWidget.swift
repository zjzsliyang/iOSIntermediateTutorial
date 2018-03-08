//
//  ToneWidget.swift
//  AudioSynthesis
//
//  Created by Simon Gladman on 14/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ToneWidget: UIControl
{
    fileprivate let frequencyDial = NumericDial(frame: CGRect.zero)
    fileprivate let amplitudeDial = NumericDial(frame: CGRect.zero)
    fileprivate let sineWaveRenderer = SineWaveRenderer(frame: CGRect.zero)
    
    fileprivate let channelNumber: Int
    
    required init(channelNumber: Int, frame: CGRect)
    {
        self.channelNumber = channelNumber
        
        super.init(frame: frame)
        
        addSubview(sineWaveRenderer)
        addSubview(frequencyDial)
        addSubview(amplitudeDial)
        
        frequencyDial.addTarget(self, action: #selector(ToneWidget.dialChangeHander), for: UIControlEvents.valueChanged)
        amplitudeDial.addTarget(self, action: #selector(ToneWidget.dialChangeHander), for: UIControlEvents.valueChanged)
        
        frequencyDial.currentValue = 0.25 * Float(channelNumber % 4 + 1)
        amplitudeDial.currentValue = 0.25 //* Float(4 - channelNumber % 4)
        
        dialChangeHander()
    }

    func getChannelNumber() -> Int
    {
        return channelNumber
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getFrequencyAmplitudePair() -> FrequencyAmplitudePair
    {
        return FrequencyAmplitudePair(frequency: frequencyDial.currentValue, amplitude: amplitudeDial.currentValue)
    }
    
    @objc func dialChangeHander()
    {
        sineWaveRenderer.setFrequencyAmplitudePairs([getFrequencyAmplitudePair()])
        
        sendActions(for: UIControlEvents.valueChanged)
    }
    
    override func didMoveToWindow()
    {
        sineWaveRenderer.frame = CGRect(x: 65, y: 130, width: 90, height: 125)
        frequencyDial.frame = CGRect(x: 55, y: 300, width: 105, height: 105)
        amplitudeDial.frame = CGRect(x: 55, y: 430, width: 105, height: 105)
        
        frequencyDial.labelFunction = frequencyLabelFunction
        amplitudeDial.labelFunction = amplitudeLabelFunction
        
        sineWaveRenderer.setFrequencyAmplitudePairs([getFrequencyAmplitudePair()])
    }
    
    func frequencyLabelFunction(_ value: Float) -> String
    {
        let valueAsString = NSString(format: "%d", Int(value * Constants.frequencyScale))
        return "Frequency\n\(valueAsString)"
    }
    
    func amplitudeLabelFunction(_ value: Float) -> String
    {
        let valueAsString = NSString(format: "%.4f", value)
        return "Amplitude\n\(valueAsString)"
    }
}
