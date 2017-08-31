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
        
        let frame = CGRect(x: 0, y: 70, width: self.topTenChartView.bounds.size.width, height: self.topTenChartView.bounds.size.height - 70)
        var chartSettings = ChartSettings()
        
        let chartConfig = BarsChartConfig(
          chartSettings: chartSettings,
          valsAxisConfig: ChartAxisConfig(from: 0, to: Double(finalDataArray[9]["aqi"] as! String)!, by: 2)
        )
        
        var cityBars = [(String, Double)]()
        for i in 0...9 {
          var temp = (finalDataArray[i]["name"], Double(finalDataArray[i]["aqi"] as! String)!)
          cityBars.append(temp as! (String, Double))
        }
        let chart = BarsChart(
          frame:frame,
          chartConfig: chartConfig,
          xTitle: "城市",
          yTitle: "空气质量",
          bars: cityBars,
          color: UIColor.red,
          barWidth: 40
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
        
        let labelSettings = ChartLabelSettings(font: UIFont(name: "Helvetica", size: 16)!)
        
        var chartPoints = [ChartPoint]()
        
        for i in 0...4 {
          let date = (finalDataArray[i]["date"] as! String)
          let index = date.index(date.startIndex, offsetBy: 5)
          
          let tempChartPoint = ChartPoint(x: ChartAxisValueString(date.substring(from: index
          ), order: i, labelSettings: labelSettings), y: ChartAxisValueDouble(Double(finalDataArray[i]["aqi"]!)!))
          chartPoints.append(tempChartPoint)
        }
        
        
        let xValues = chartPoints.map { $0.x }
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 8, maxSegmentCount: 20, multiple: 2, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: labelSettings) }, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "日期", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "空气质量", settings: labelSettings.defaultVertical()))
        
        let chartFrame = CGRect(x: 0, y: 70, width: self.topTenChartView.bounds.size.width, height: self.topTenChartView.bounds.size.height - 70)
        var chartSettings = ChartSettings()
        chartSettings.top = 10
        chartSettings.trailing = 20
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 1, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: 0.2)
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
        
        let labelSettings = ChartLabelSettings(font: UIFont(name: "Helvetica", size: 16)!)
        
        var chartPoints = [ChartPoint]()
        
        for i in 0...6 {
          let date = (finalDataArray[i]["date"] as! String)
          let index = date.index(date.startIndex, offsetBy: 5)
          let tempChartPoint = ChartPoint(x: ChartAxisValueString(date.substring(from: index), order: i, labelSettings: labelSettings), y: ChartAxisValueDouble(Double(finalDataArray[i]["high"]!)!))
          chartPoints.append(tempChartPoint)
        }
        
        let xValues = chartPoints.map { $0.x }

        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 8, maxSegmentCount: 20, multiple: 2, axisValueGenerator: { ChartAxisValueDouble($0, labelSettings: labelSettings) }, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "日期", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "温度", settings: labelSettings.defaultVertical()))
        
        let chartFrame = CGRect(x: 0, y: 70, width: self.temperatureChartView.bounds.size.width, height: self.temperatureChartView.bounds.size.height - 70)

        var chartSettings = ChartSettings()
        chartSettings.top = 10
        chartSettings.trailing = 20
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, lineWidth: 1, animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: 0.2)
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
