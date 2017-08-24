//
//  WeatherManager.swift
//  Weather
//
//  Created by 罗忠金 on 19/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import Foundation

class MyWeatherManager {
  
//      static let basicInfoUrl = "https://api.seniverse.com/v3/weather/now.json?key=qxlcxsjzcitnsr8q&location=beijing&language=zh-Hans&unit=c"
    
    static let myKey = "kv3qdlu4ku268ypr"
  
  
  static func setWeatherTemperatureChart(updateUI: @escaping (_ finalData: [[String: String]]) -> Void) -> Void {
    let finalData = [Dictionary<String, String>]()
    updateUI(finalData)
  }
  
  
  static func initWeatherBasicInfo(updateUI: @escaping (_ finalData: [String: String]) -> Void) {
    MyLocationManager.initLocation()
    let locationGeted = Notification.Name.init(rawValue: "Location Update")
    NotificationCenter.default.addObserver(forName: locationGeted, object: nil, queue: nil) { (notification) in
      MyWeatherManager.setWeatherBasicInfo(updateUI: updateUI)
    }
  }
  
  static func setWeatherBasicInfoBySearchText(searchText: String, updateUI: @escaping (_ finalData: [String: String]) -> Void) {
    MyLocationManager.setCurrentLocation(current: searchText)
    //setWeatherBasicInfo(updateUI: updateUI)
    let locationGeted = Notification.Name.init(rawValue: "Location Update")
    NotificationCenter.default.post(name: locationGeted, object: nil)
  }
  
  
  static func setWeatherForecastInfo(updateUI: @escaping (_ finalData: [[String: String]]) -> Void) {
    let forecastBasicInfoUrl = "https://api.seniverse.com/v3/weather/daily.json?key=\(myKey)&location=\(MyLocationManager.currentLocation)&language=zh-Hans&unit=c&start=1&days=7"
    let forcastSunInfo = "https://api.seniverse.com/v3/geo/sun.json?key=\(myKey)&location=\(MyLocationManager.currentLocation)&language=zh-Hans&start=1&days=7"
    var finalData = [Dictionary<String, String>]()
    MyHttpManager.getJsonData(url: forecastBasicInfoUrl) { (forecastBasicResult) in
      //print(forecastBasicResult)
      if(!forecastBasicResult.isEmpty) {
        let forecastBasicDataArray = (((forecastBasicResult["results"] as! [[String: Any]])[0])["daily"] as! [[String: String]])
        for i in 0...6 {
          finalData.append(setForeCastBasicValue(forecastBasicDataArray: forecastBasicDataArray, index: i))
        }
        MyHttpManager.getJsonData(url: forcastSunInfo) { (forcastSunInfoResult) in
          let forecastSunDataArray = ((((forcastSunInfoResult["results"] as! [[String: Any]])[0])["sun"]) as! [[String: String]])
          for i in 0...6 {
            setForeCastSunValue(finalData: &finalData, forecaseSunDataArray: forecastSunDataArray, index: i)
          }
          updateUI(finalData)
        }
      } else {
        print("error")
      }
    }
  }
  
  static func setWeatherQualiyRankingInfo(updateUI: @escaping (_ finalData: [[String: String]]) -> Void) {
    let qualiyRankingInfoUrl = "https://api.seniverse.com/v3/air/ranking.json?key=\(myKey)&language=zh-Hans"
    var finalData = [Dictionary<String, String>]()
    MyHttpManager.getJsonData(url: qualiyRankingInfoUrl) { (qualiyRankingResult) in
      
      if(!qualiyRankingResult.isEmpty) {
        let qualiyRankingDataArray = ((qualiyRankingResult["results"] as! [[String: Any]])
        )
        print(qualiyRankingDataArray)
        for i in 0...9 {
          print(qualiyRankingDataArray[i])
          var temp = Dictionary<String, String>()
          temp["name"] = ((qualiyRankingDataArray[i]["location"] as! [String: String])["name"]!)
          temp["aqi"] = (qualiyRankingDataArray[i]["aqi"] as! String)
          finalData.append(temp)
        }
        updateUI(finalData)
      } else {
        print("error")
      }
    }
  }
  
  static func setWeatherForecastQualityInfo(updateUI: @escaping (_ finalData: [[String: String]]) -> Void) {
    let forecastQualtiyInfoUrl = "https://api.seniverse.com/v3/air/daily.json?key=\(myKey)&language=zh-Hans&days=5&location=\(MyLocationManager.currentLocation)"
    var finalData = [Dictionary<String, String>]()
    MyHttpManager.getJsonData(url: forecastQualtiyInfoUrl) { (forecastQualityResult) in
      //print(forecastBasicResult)
      if(!forecastQualityResult.isEmpty) {
        let forecastQualityDataArray = (((forecastQualityResult["results"] as! [[String: Any]])[0])["daily"] as! [[String: String]])
        //print(forecastQualityDataArray)
        for i in 0...4 {
          var temp = Dictionary<String, String>()
          temp["date"] = (forecastQualityDataArray[i]["date"]!)
          temp["aqi"] = (forecastQualityDataArray[i]["aqi"]!)
          finalData.append(temp)
        }
        updateUI(finalData)
      } else {
        print("error")
      }
    }
  }
  
  static func setForeCastBasicValue(forecastBasicDataArray: [Dictionary<String, String>], index: Int) -> Dictionary<String, String> {
    var temp = Dictionary<String, String>()
    temp["date"] = forecastBasicDataArray[index]["date"]
    temp["code_day"] = forecastBasicDataArray[index]["code_day"]
    temp["text_day"] = forecastBasicDataArray[index]["text_day"]
    temp["high"] = forecastBasicDataArray[index]["high"]
    temp["low"] = forecastBasicDataArray[index]["low"]
    return temp
  }
  
  static func setForeCastSunValue(finalData: inout [Dictionary<String, String>], forecaseSunDataArray: [Dictionary<String, String>], index: Int) -> Void {
    
    finalData[index]["sunrise"] = forecaseSunDataArray[index]["sunrise"]
    finalData[index]["sunset"] = forecaseSunDataArray[index]["sunset"]
    
  }
  
  
  
  static func setWeatherBasicInfo(updateUI: @escaping (_ finalData: [String: String]) -> Void) -> Void {
    let basicInfoUrl = "https://api.seniverse.com/v3/weather/now.json?key=\(myKey)&location=\(MyLocationManager.currentLocation)&language=zh-Hans&unit=c"
    let sunInfoUrl = "https://api.seniverse.com/v3/geo/sun.json?key=\(myKey)&location=\(MyLocationManager.currentLocation)&language=zh-Hans&start=0&days=1"
    let moonInfoUrl = "https://api.seniverse.com/v3/geo/moon.json?key=\(myKey)&location=\(MyLocationManager.currentLocation)&language=zh-Hans&start=0&days=1"
    let airInfoUrl = "https://api.seniverse.com/v3/air/now.json?key=\(myKey)&location=\(MyLocationManager.currentLocation)&language=zh-Hans&scope=city"
    let lifeInfoUrl = "https://api.seniverse.com/v3/life/suggestion.json?key=\(myKey)&location=\(MyLocationManager.currentLocation)&language=zh-Hans"
    
    var finalData = Dictionary<String, String>()
    
    MyHttpManager.getJsonData(url: basicInfoUrl) { (basicResult) in
      
      if (!basicResult.isEmpty) {
        let currentConditions = ((basicResult["results"] as! [[String: Any]])[0])["now"] as! [String: Any]
        //print(currentConditions)
        finalData["temperature"] = currentConditions["temperature"] as? String
        finalData["code"] = currentConditions["code"] as? String
        finalData["text"] = currentConditions["text"] as? String
        MyHttpManager.getJsonData(url: sunInfoUrl) { (sunResult) in
          if(!sunResult.isEmpty) {
            //print(sunResult["results"][0])
            let sunConditions = (((sunResult["results"] as! [[String: Any]])[0])["sun"] as! [[String: Any]])[0] as [String: Any]
            //print(sunConditions)
            finalData["sunrise"] = sunConditions["sunrise"] as? String
            finalData["sunset"] = sunConditions["sunset"] as? String
            //print(finalData["sunrise"])
            MyHttpManager.getJsonData(url: moonInfoUrl) { (moonResult) in
              if(!moonResult.isEmpty) {
                //print(sunResult["results"][0])
                let moonConditions = (((moonResult["results"] as! [[String: Any]])[0])["moon"] as! [[String: Any]])[0] as [String: Any]
                //print(moonConditions)
                finalData["moonrise"] = moonConditions["rise"] as? String
                finalData["moonset"] = moonConditions["set"] as? String
                MyHttpManager.getJsonData(url: airInfoUrl) { (airResult) in
                  if(!airResult.isEmpty) {
                    let airConditions = ((((airResult["results"] as! [[String: Any]])[0])["air"]) as! [String: Any])["city"] as! [String: Any]
                    //print(airConditions)
                    finalData["quality"] = airConditions["quality"] as? String
                    finalData["pm25"] = airConditions["pm25"] as? String
                    
                    
                    MyHttpManager.getJsonData(url: lifeInfoUrl) { (lifeResult) in
                      print("next")
                      if(!lifeResult.isEmpty) {
                        let lifeConditions = ((((lifeResult["results"] as! [[String: Any]])[0])["suggestion"]) as! [String: Any])["dressing"] as![String: Any]
                        //print(lifeConditions)
                        finalData["details"] = lifeConditions["details"] as? String
                        updateUI(finalData)
                      } else {
                        print("error")
                      }
                    }
                  } else {
                    print("error")
                  }
                }
              } else {
                print("error")
              }
            }
          } else {
            print("error")
          }
        }
      } else {
        print("error")
      }
    }
  }
}

