//
//  MyLocationManager.swift
//  Weather
//
//  Created by 罗忠金 on 18/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

//自封装LocationManager,以便在多个页面共享地理位置
class MyLocationManager: CLLocationManager, CLLocationManagerDelegate {

  static let locationShared = MyLocationManager()

  var currentLocation = "上海嘉定" //系统默认定位

  var myCoordinate = CLLocationCoordinate2D()

  //设置定位
 func setCurrentLocation(current: String) {
    self.currentLocation = current
  }

  //初始化定位信息
  func initLocation() -> Void {
    //设置位置精度
    self.desiredAccuracy = kCLLocationAccuracyBest
    //获取定位服务
    self.requestWhenInUseAuthorization()
    //设置委托对象
    self.delegate = self
    //获取一次坐标
    self.requestLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    //获取最新地理坐标
    let currentLocation = locations[0]
    myCoordinate.latitude = currentLocation.coordinate.latitude
    myCoordinate.longitude = currentLocation.coordinate.longitude

    
    let location = CLLocation(latitude: myCoordinate.latitude, longitude: myCoordinate.longitude)

    let geoCoder = CLGeocoder()
    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")//将语言强制为英语，方便获取省市拼音
    //地理反编码
    geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
      guard let addressDict = placemarks?[0].addressDictionary else {
        return
      }

      //获取省市拼音，以便http请求使用
      if let province = addressDict["State"] as? String {
        if let city = addressDict["Name"] as? String {
          //记录省市
          self.currentLocation = "\(province)\(city)"
          let locationGeted = Notification.Name.init(rawValue: "Location Update")
          NotificationCenter.default.post(name: locationGeted, object: nil)
        }
      } else {
        print("地理反编码错误")
      }
      UserDefaults.standard.removeObject(forKey: "AppleLanguages")//将语言转换回系统语言
    })
  }

  //定位错误时调用
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }

  override init() {
    super.init()
  }

}
