//
//  chartsViewController.swift
//  weather
//
//  Created by 罗忠金 on 16/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit
import SwiftCharts


class ChartsViewController: UIViewController {
    fileprivate var chart: Chart? 
    @IBOutlet weak var myview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("haha")
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
//        let cp1 = ChartPoint(x: MyMultiLabelAxisValue(myVal: 32), y: ChartAxisValueDouble(31))
//        let cp2 = ChartPoint(x: MyMultiLabelAxisValue(myVal: 33), y: ChartAxisValueDouble(32))
//        let cp3 = ChartPoint(x: MyMultiLabelAxisValue(myVal: 34), y: ChartAxisValueDouble(28))
//        let cp4 = ChartPoint(x: MyMultiLabelAxisValue(myVal: 32), y: ChartAxisValueDouble(34))
//        let cp5 = ChartPoint(x: MyMultiLabelAxisValue(myVal: 40), y: ChartAxisValueDouble(25))
        let cp1 = ChartPoint(x: ChartAxisValueString("d1", order: 1, labelSettings: labelSettings), y: ChartAxisValueDouble(31))
        let cp2 = ChartPoint(x: ChartAxisValueString("d2", order: 2, labelSettings: labelSettings), y: ChartAxisValueDouble(32))
        let cp3 = ChartPoint(x: ChartAxisValueString("d3", order: 3, labelSettings: labelSettings), y: ChartAxisValueDouble(28))
        let cp4 = ChartPoint(x: ChartAxisValueString("d4", order: 4, labelSettings: labelSettings), y: ChartAxisValueDouble(34))
        let cp5 = ChartPoint(x: ChartAxisValueString("d5", order: 5, labelSettings: labelSettings), y: ChartAxisValueDouble(25))
        let cp6 = ChartPoint(x: ChartAxisValueString("d7", order: 6, labelSettings: labelSettings), y: ChartAxisValueDouble(30))
        let cp7 = ChartPoint(x: ChartAxisValueString("d8", order: 7, labelSettings: labelSettings), y: ChartAxisValueDouble(35))
        

        
        
        let chartPoints = [cp1, cp2, cp3, cp4, cp5, cp6, cp7]
        
        let xValues = chartPoints.map{$0.x}
        print(xValues[1])
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "日期", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "温度", settings: labelSettings.defaultVertical()))
        
        let chartFrame = ExamplesDefaults.chartFrame(myview.bounds)
        var chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        chartSettings.trailing = 20
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 1, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        //        Chart(frame: <#T##CGRect#>, settings: <#T##ChartSettings#>, layers: <#T##[ChartLayer]#>)
        //        Chart(frame: <#T##CGRect#>, innerFrame: <#T##CGRect?#>, settings: <#T##ChartSettings#>, layers: <#T##[ChartLayer]#>)
        let chart = Chart(
            frame: chartFrame,
            //innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer
            ]
        )
        
        myview.addSubview(chart.view)
        self.chart = chart
    }
}

//private class MyMultiLabelAxisValue: ChartAxisValue {
//
//    fileprivate let myVal: Int
//    fileprivate let derivedVal: Double
//
//    init(myVal: Int) {
//        self.myVal = myVal
//        self.derivedVal = Double(myVal) / 5.0
//        super.init(scalar: Double(myVal))
//    }
//
//    override var labels:[ChartAxisLabel] {
//        return [
//            ChartAxisLabel(text: "\(myVal)", settings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 18), fontColor: UIColor.black)),
//            ChartAxisLabel(text: "第\(myVal)天", settings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 20), fontColor: UIColor.black)),
//            ChartAxisLabel(text: "\(derivedVal)", settings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 14), fontColor: UIColor.purple))
//        ]
//    }
//}

