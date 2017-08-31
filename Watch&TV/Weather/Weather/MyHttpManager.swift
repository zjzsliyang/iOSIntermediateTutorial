//
//  MyHttpManager.swift
//  Weather
//
//  Created by 罗忠金 on 20/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import Foundation

//网络请求类
class MyHttpManager {
  static func getJsonData(url: String, dealWithJson: @escaping (_ jsonResult: [String: Any]) throws -> Void) -> Void {
    //确定请求路径，addingPercentEncoding -- 编码带中文的URL
    let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    //根据会话对象创建一个Task
    var jsonResult = Dictionary<String, Any>()
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
      if error != nil {
        print("数据获取失败")
        return
      } else {
        do {
          //存储json数据
          jsonResult = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
          //解析处理json数据
          try dealWithJson(jsonResult)
        } catch _ as NSError {
          print("数据解析失败")
        }
      }
    }.resume()
  }
}
