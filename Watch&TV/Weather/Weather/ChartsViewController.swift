//
//  ChartsViewController.swift
//  Weather
//
//  Created by 罗忠金 on 16/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit
import SwiftCharts


class ChartsViewController: UIViewController {
  fileprivate var temperatureChart: Chart?
  fileprivate var qualityChart: Chart?
  fileprivate var chart: Chart? // arc
  
  @IBOutlet weak var temperatureChartView: UIView!
  @IBOutlet weak var qualityChartView: UIView!
  @IBOutlet weak var topTenChartView: UIView!
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTemperatureChartView()
    setQualityChartView()
    setTopCityChartView()
    temperatureChartView.isHidden = false
    qualityChartView.isHidden = true
    topTenChartView.isHidden = true
    
    let chartNotification = Notification.Name.init(rawValue: "Chart View Update")
    NotificationCenter.default.addObserver(forName: chartNotification, object: nil, queue: nil) { _ in
      self.setTemperatureChartView()
      self.setQualityChartView()
      self.setTopCityChartView()
    }
  }
  
  @IBAction func indexChanged(_ sender: UISegmentedControl) {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      temperatureChartView.isHidden = false
      qualityChartView.isHidden = true
      topTenChartView.isHidden = true
      break
    case 1:
      temperatureChartView.isHidden = true
      qualityChartView.isHidden = false
      topTenChartView.isHidden = true
      break
    case 2:
      temperatureChartView.isHidden = true
      qualityChartView.isHidden = true
      topTenChartView.isHidden = false
    default:
      break
    }
  }
  
  func setTopCityChartView() -> Void {
    
    MyWeatherManager.setWeatherQualiyRankingInfo() { (finalDataArray) in
      DispatchQueue.main.async() {
        let chartConfig = BarsChartConfig(
          chartSettings: ExamplesDefaults.chartSettingsWithPanZoom,
          valsAxisConfig: ChartAxisConfig(from: 0, to: Double(finalDataArray[9]["aqi"]!)!, by: 2),
          xAxisLabelSettings: ExamplesDefaults.labelSettings,
          yAxisLabelSettings: ExamplesDefaults.labelSettings.defaultVertical()
        )
        
        var cityBars = [(String, Double)]()
        for i in 0...9 {
          let temp = (finalDataArray[i]["name"], Double(finalDataArray[i]["aqi"]!)!)
          cityBars.append(temp as! (String, Double))
        }
        
        let chart = BarsChart(
          frame: ExamplesDefaults.chartFrame(self.topTenChartView.bounds),
          chartConfig: chartConfig,
          xTitle: "城市",
          yTitle: "空气质量",
          bars: cityBars,
          color: UIColor.red,
          barWidth: Env.iPad ? 40 : 20
        )
        
        self.topTenChartView.addSubview(chart.view)
        self.chart = chart
      }
    }
    
  }
  
  func setQualityChartView() -> Void {
    MyWeatherManager.setWeatherForecastQualityInfo() { (finalDataArray) in
      DispatchQueue.main.async() {
        
        if(self.qualityChart?.view != nil) {
          (self.qualityChart?.view)!.removeFromSuperview()
        }
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        var chartPoints = [ChartPoint]()
        
        for i in 0...4 {
          let date = (finalDataArray[i]["date"]!)
          let index = date.index(date.startIndex, offsetBy: 5)
          let tempChartPoint = ChartPoint(x: ChartAxisValueString(String(describing: date[index...]), order: i, labelSettings: labelSettings), y: ChartAxisValueDouble(Double(finalDataArray[i]["aqi"]!)!))
          chartPoints.append(tempChartPoint)
        }
        
        
        let xValues = chartPoints.map { $0.x }
        print(xValues[1])
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 8, maxSegmentCount: 20, multiple: 2, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: labelSettings) }, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "日期", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "空气质量", settings: labelSettings.defaultVertical()))
        
        let chartFrame = ExamplesDefaults.chartFrame(self.temperatureChartView.bounds)
        var chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        chartSettings.trailing = 20
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, _) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 1, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        self.qualityChart = Chart(
          frame: chartFrame,
          settings: chartSettings,
          layers: [
            xAxisLayer,
            yAxisLayer,
            guidelinesLayer,
            chartPointsLineLayer
          ]
        )
        self.qualityChartView.addSubview((self.qualityChart?.view)!)
        
      }
    }
  }
  
  func setTemperatureChartView() -> Void {
    MyWeatherManager.setWeatherForecastInfo() { (finalDataArray) in
      DispatchQueue.main.async() {
        
        if (self.temperatureChart?.view != nil) {
          (self.temperatureChart?.view)!.removeFromSuperview()
        }
        
        print(Double(finalDataArray[0]["high"]!)!)
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        //                let cp1 = ChartPoint(x: ChartAxisValueString(finalDataArray[0]["date"]!, order: 1, labelSettings: labelSettings), y: ChartAxisValueDouble(Double(finalDataArray[0]["high"]!)!))
        //                let cp2 = ChartPoint(x: ChartAxisValueString(finalDataArray[1]["date"]!, order: 2, labelSettings: labelSettings), y: ChartAxisValueDouble(32))
        //                let cp3 = ChartPoint(x: ChartAxisValueString("d3", order: 3, labelSettings: labelSettings), y: ChartAxisValueDouble(28))
        //                let cp4 = ChartPoint(x: ChartAxisValueString("d4", order: 4, labelSettings: labelSettings), y: ChartAxisValueDouble(34))
        //                let cp5 = ChartPoint(x: ChartAxisValueString("d5", order: 5, labelSettings: labelSettings), y: ChartAxisValueDouble(25))
        //                let cp6 = ChartPoint(x: ChartAxisValueString("d7", order: 6, labelSettings: labelSettings), y: ChartAxisValueDouble(30))
        //                let cp7 = ChartPoint(x: ChartAxisValueString("d8", order: 7, labelSettings: labelSettings), y: ChartAxisValueDouble(35))
        
        var chartPoints = [ChartPoint]()
        
        for i in 0...6 {
          let date = (finalDataArray[i]["date"]!)
          let index = date.index(date.startIndex, offsetBy: 5)
          let tempChartPoint = ChartPoint(x: ChartAxisValueString(String(describing: date[index...]), order: i, labelSettings: labelSettings), y: ChartAxisValueDouble(Double(finalDataArray[i]["high"]!)!))
          chartPoints.append(tempChartPoint)
        }
        
        
        
        let xValues = chartPoints.map { $0.x }
        print(xValues[1])
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 8, maxSegmentCount: 20, multiple: 2, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: labelSettings) }, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "日期", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "温度", settings: labelSettings.defaultVertical()))
        
        let chartFrame = ExamplesDefaults.chartFrame(self.temperatureChartView.bounds)
        var chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        chartSettings.trailing = 20
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, _) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 1, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        self.temperatureChart = Chart(
          frame: chartFrame,
          settings: chartSettings,
          layers: [
            xAxisLayer,
            yAxisLayer,
            guidelinesLayer,
            chartPointsLineLayer
          ]
        )
        
        self.temperatureChartView.addSubview((self.temperatureChart?.view)!)
      }
    }
  }
}
