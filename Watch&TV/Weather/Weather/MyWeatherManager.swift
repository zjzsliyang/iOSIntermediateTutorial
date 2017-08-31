//
//  WeatherManager.swift
//  Weather
//
//  Created by 罗忠金 on 19/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import Foundation

class MyWeatherManager {
    
    
    //心知天气密钥
    static let myKey = "kv3qdlu4ku268ypr"
    
    static func initWeatherBasicInfo(updateUI: @escaping (_ finalData: [String: String]) -> Void) {
        MyLocationManager.locationShared.initLocation()
        let locationGeted = Notification.Name.init(rawValue: "Location Update")
        NotificationCenter.default.addObserver(forName: locationGeted, object: nil, queue: nil) { (notification) in
            MyWeatherManager.setWeatherBasicInfo(updateUI: updateUI)
        }
    }
    
    //根据搜索内容更新数据
    static func setWeatherBasicInfoBySearchText(searchText: String, updateUI: @escaping (_ finalData: [String: String]) -> Void) {
        MyLocationManager.locationShared.setCurrentLocation(current: searchText)
        let locationGeted = Notification.Name.init(rawValue: "Location Update")
        NotificationCenter.default.post(name: locationGeted, object: nil)
    }
    
    //天气预报 & 图表 -- 温度趋势
    static func setWeatherForecastInfo(updateUI: @escaping (_ finalData: [[String: String]]) -> Void) {
        //获取天气情况
        let forecastBasicInfoUrl = "https://api.seniverse.com/v3/weather/daily.json?key=\(myKey)&location=\(MyLocationManager.locationShared.currentLocation)&start=1&days=7"
        
        //获取日出日落时间
        let forcastSunInfo = "https://api.seniverse.com/v3/geo/sun.json?key=\(myKey)&location=\(MyLocationManager.locationShared.currentLocation)&start=1&days=7"
        
        var finalData = [Dictionary<String, String>]()
        MyHttpManager.getJsonData(url: forecastBasicInfoUrl) { (forecastBasicResult) in
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
    
    //图表 -- 城市空气质量排名
    static func setWeatherQualiyRankingInfo(updateUI: @escaping (_ finalData: [[String: String]]) -> Void) {
        let qualiyRankingInfoUrl = "https://api.seniverse.com/v3/air/ranking.json?key=\(myKey)"
        var finalData = [Dictionary<String, String>]()
        MyHttpManager.getJsonData(url: qualiyRankingInfoUrl) { (qualiyRankingResult) in
            let qualiyRankingDataArray = ((qualiyRankingResult["results"] as! [[String: Any]])
            )
            for i in 0...9 {
                var temp = Dictionary<String, String>()
                temp["name"] = ((qualiyRankingDataArray[i]["location"] as! [String: String])["name"] as! String)
                temp["aqi"] = (qualiyRankingDataArray[i]["aqi"] as! String)
                finalData.append(temp)
            }
            updateUI(finalData)
        }
    }
    
    //图表 -- 空气质量趋势
    static func setWeatherForecastQualityInfo(updateUI: @escaping (_ finalData: [[String: String]]) -> Void) {
        let forecastQualtiyInfoUrl = "https://api.seniverse.com/v3/air/daily.json?key=\(myKey)&days=5&location=\(MyLocationManager.locationShared.currentLocation)"
        var finalData = [Dictionary<String, String>]()
        MyHttpManager.getJsonData(url: forecastQualtiyInfoUrl) { (forecastQualityResult) in
            if(!forecastQualityResult.isEmpty) {
                let forecastQualityDataArray = (((forecastQualityResult["results"] as! [[String: Any]])[0])["daily"] as! [[String: String]])
                for i in 0...4 {
                    var temp = Dictionary<String, String>()
                    temp["date"] = (forecastQualityDataArray[i]["date"] as! String)
                    temp["aqi"] = (forecastQualityDataArray[i]["aqi"] as! String)
                    finalData.append(temp)
                }
                updateUI(finalData)
            } else {
                print("error")
            }
        }
    }
    
    
    //当前天气情况
    static func setWeatherBasicInfo(updateUI: @escaping (_ finalData: [String: String]) -> Void) -> Void {
        let basicInfoUrl = "https://api.seniverse.com/v3/weather/now.json?key=\(myKey)&location=\(MyLocationManager.locationShared.currentLocation)"
        let sunInfoUrl = "https://api.seniverse.com/v3/geo/sun.json?key=\(myKey)&location=\(MyLocationManager.locationShared.currentLocation)&start=0&days=1"
        let moonInfoUrl = "https://api.seniverse.com/v3/geo/moon.json?key=\(myKey)&location=\(MyLocationManager.locationShared.currentLocation)&start=0&days=1"
        let airInfoUrl = "https://api.seniverse.com/v3/air/now.json?key=\(myKey)&location=\(MyLocationManager.locationShared.currentLocation)"
        let lifeInfoUrl = "https://api.seniverse.com/v3/life/suggestion.json?key=\(myKey)&location=\(MyLocationManager.locationShared.currentLocation)"
        var finalData = Dictionary<String, String>()
        MyHttpManager.getJsonData(url: basicInfoUrl) { (basicResult) in
            let detailAddress = (((basicResult["results"] as! [[String: Any]])[0])["location"] as! [String: Any])["path"] as! String
            finalData["detailAddress"] = detailAddress
            let currentConditions = ((basicResult["results"] as! [[String: Any]])[0])["now"] as! [String: Any]
            finalData["temperature"] = currentConditions["temperature"] as? String
            finalData["code"] = currentConditions["code"] as? String
            finalData["text"] = currentConditions["text"] as? String
            MyHttpManager.getJsonData(url: sunInfoUrl) { (sunResult) in
                let sunConditions = (((sunResult["results"] as! [[String: Any]])[0])["sun"] as! [[String: Any]])[0] as [String: Any]
                finalData["sunrise"] = sunConditions["sunrise"] as? String
                finalData["sunset"] = sunConditions["sunset"] as? String
                MyHttpManager.getJsonData(url: moonInfoUrl) { (moonResult) in
                    let moonConditions = (((moonResult["results"] as! [[String: Any]])[0])["moon"] as! [[String: Any]])[0] as [String: Any]
                    finalData["moonrise"] = moonConditions["rise"] as? String
                    finalData["moonset"] = moonConditions["set"] as? String
                    MyHttpManager.getJsonData(url: airInfoUrl) { (airResult) in
                        let airConditions = ((((airResult["results"] as! [[String: Any]])[0])["air"]) as! [String: Any])["city"] as! [String: Any]
                        finalData["quality"] = airConditions["quality"] as? String
                        finalData["pm25"] = airConditions["pm25"] as? String
                        MyHttpManager.getJsonData(url: lifeInfoUrl) { (lifeResult) in
                            let lifeConditions = ((((lifeResult["results"] as! [[String: Any]])[0])["suggestion"]) as! [String: Any])["dressing"] as![String: Any]
                            finalData["details"] = lifeConditions["details"] as? String
                            updateUI(finalData)
                        }
                    }
                }
            }
        }
    }
}
