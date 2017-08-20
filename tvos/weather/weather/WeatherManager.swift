//
//  WeatherManager.swift
//  weather
//
//  Created by 罗忠金 on 19/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import Foundation

class WeatherManager {
    
    
    static func setWeatherInfo(update:@escaping (_ jsonData:[String:Any])->Void) -> Void {
//        let myLabel = "Hello"
//        update(myLabel)
        
//        let url = URL(string:"http://httpbin.org/get?foo=bar")
//        let session = URLSession.shared
//        URLSession.shared.dataTask
//        
        let urlString = "https://api.forecast.io/forecast/apiKey/37.5673776,122.048951"
        
        let url = URL(string:"https://api.seniverse.com/v3/weather/now.json?key=qxlcxsjzcitnsr8q&location=beijing&language=zh-Hans&unit=c")
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("error0")
            } else {
                do {
                    //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                    let jsonResult = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    update(jsonResult)
                    
                } catch let error as NSError {
                    print("error1")
                }
            }
            
            }.resume()
    }
    
}
