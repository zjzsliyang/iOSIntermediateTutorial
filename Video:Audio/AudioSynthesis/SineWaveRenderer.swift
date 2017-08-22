//
//  SineWaveRenderer.swift
//  AudioSynthesis
//
//  Created by Simon Gladman on 14/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class SineWaveRenderer: UIControl
{
    let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    fileprivate var frequencyAplitudePairs = [FrequencyAmplitudePair]()
    
    var operation: SineWaveRendererOperation?
    let operationQueue = OperationQueue()
    var pendingOperation = false

    
    override func didMoveToSuperview()
    {
        addSubview(imageView)
        
        backgroundColor = UIColor.black
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews()
    {
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    
    final func setFrequencyAmplitudePairs(_ value: [FrequencyAmplitudePair])
    {
        frequencyAplitudePairs = value
        
        if frame == CGRect.zero
        {
            return
        }
        else if let _operation = operation
        {
            if _operation.isExecuting
            {
                self.pendingOperation = true
                return
            }
        }
        
        operation = SineWaveRendererOperation(frequencyAplitudePairs: frequencyAplitudePairs, width: Int(frame.width), height: Int(frame.height))
        
        operation?.completionBlock = completionBlock
        
        operationQueue.addOperation(operation!)
    }
    
    final func completionBlock()
    {
        if let _operation = operation
        {
            DispatchQueue.main.async(execute: {
                self.imageView.image = _operation.finalImage
                
                if self.pendingOperation
                {
                    self.pendingOperation = false;
                    self.setFrequencyAmplitudePairs(self.frequencyAplitudePairs)
                }
            })
        }
    }
    
}

class SineWaveRendererOperation: Operation
{
    fileprivate let colorRef = UIColor.yellow.cgColor.components
    fileprivate let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    fileprivate let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    fileprivate var frequencyAplitudePairs: [FrequencyAmplitudePair]!
    fileprivate var width: Int!
    fileprivate var height: Int!
    
    var finalImage: UIImage?
    
    init (frequencyAplitudePairs: [FrequencyAmplitudePair], width: Int, height: Int)
    {
        self.frequencyAplitudePairs = frequencyAplitudePairs
        self.width = width
        self.height = height
    }
    
    override func main() -> ()
    {
        var pixelArray = [PixelData](repeating: PixelData(a: 0, r:0, g: 0, b: 0), count: width * height);
        var previousCurveY:Double!
        
        for i in 1 ..< width
        {
            let scale = M_PI * 5
            let curveX = Double(i)
            
            var curveY = Double(height / 2)
            
            for pair in frequencyAplitudePairs
            {
                let frequency = Double(pair.frequency)
                let velocity = Double(pair.amplitude)
                
                curveY += ((sin(curveX / scale * frequency * 5)) * (velocity * 10))
            }
            
            if previousCurveY == nil
            {
                previousCurveY = curveY
            }
            
            // draw line from previous
            for yy in Int(min(previousCurveY, curveY)) ... Int(max(previousCurveY, curveY))
            {
                let pixelIndex : Int = (yy * width + i);
                
                pixelArray[pixelIndex].r = UInt8(255 * (colorRef?[0])!);
                pixelArray[pixelIndex].g = UInt8(255 * (colorRef?[1])!);
                pixelArray[pixelIndex].b = UInt8(255 * (colorRef?[2])!);
                
                let pixelIndex2 : Int = pixelIndex + 1
                if pixelIndex2 < pixelArray.count
                {
                    pixelArray[pixelIndex2].r = UInt8(255 * (colorRef?[0])!);
                    pixelArray[pixelIndex2].g = UInt8(255 * (colorRef?[1])!);
                    pixelArray[pixelIndex2].b = UInt8(255 * (colorRef?[2])!);
                }
                
                let pixelIndex3 : Int = ((yy + 1) * width + i);
                if pixelIndex3 < pixelArray.count
                {
                    pixelArray[pixelIndex3].r = UInt8(255 * (colorRef?[0])!);
                    pixelArray[pixelIndex3].g = UInt8(255 * (colorRef?[1])!);
                    pixelArray[pixelIndex3].b = UInt8(255 * (colorRef?[2])!);
                }
            }
            
            previousCurveY = curveY
        }
        
        finalImage = imageFromARGB32Bitmap(pixelArray, width: Int(width), height: Int(height))
    }
    
    fileprivate func imageFromARGB32Bitmap(_ pixels:[PixelData], width:Int, height:Int)->UIImage
    {
        let bitsPerComponent:Int = 8
        let bitsPerPixel:Int = 32
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<PixelData>.size.self) as CFData)
        //UnsafePointer<UInt8>(&data)kCGRenderingIntentDefault
        let cgim = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: width * Int(MemoryLayout<PixelData>.size), space: rgbColorSpace,	bitmapInfo: bitmapInfo, provider: providerRef!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        
        
        return UIImage(cgImage: cgim!)
    }
    
}

struct PixelData
{
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}
