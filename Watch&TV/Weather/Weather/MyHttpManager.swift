//
//  MyHttpManager.swift
//  Weather
//
//  Created by 罗忠金 on 20/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import Foundation

class MyHttpManager {
  static func getJsonData(url: String, dealWithJson: @escaping (_ jsonResult: [String: Any]) -> Void) -> Void {
    let url = URL(string: url)
    var jsonResult = Dictionary<String, Any>()
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
      if error != nil {
        print("error1")
        return
      } else {
        do {
          //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
          jsonResult = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
          dealWithJson(jsonResult)
        } catch _ as NSError {
          print("error1")
        }
      }
    }.resume()
  }
}
