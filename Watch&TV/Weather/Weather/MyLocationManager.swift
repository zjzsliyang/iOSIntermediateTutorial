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

class MyLocationManager: CLLocationManager, CLLocationManagerDelegate {


  static let locationShared = MyLocationManager()
  //static var currentProvince = "上海"
  //static var currentCity = "嘉定"
  static var currentLocation = "上海嘉定"
  var flag: Bool = false

  var myCoordinate = CLLocationCoordinate2D()

  var test = CLLocation()

  var myLocations = [CLLocation]()

  static func setCurrentLocation(current: String) {
    currentLocation = current
  }
  static func initLocation() -> Void {
    //MyLocationManager.locationShared.requestAlwaysAuthorization()
    MyLocationManager.locationShared.desiredAccuracy = kCLLocationAccuracyBest
    MyLocationManager.locationShared.requestWhenInUseAuthorization()
    MyLocationManager.locationShared.delegate = MyLocationManager.locationShared
    MyLocationManager.locationShared.requestLocation()
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }


  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let currentLocation = locations[0]
    myCoordinate.latitude = currentLocation.coordinate.latitude
    myCoordinate.longitude = currentLocation.coordinate.longitude

    //        let coordinateNotification = Notification.Name.init("Get Coordinate")
    //        NotificationCenter.default.post(name: coordinateNotification, object: nil)

    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: myCoordinate.latitude, longitude: myCoordinate.longitude)

    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
    geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
      guard let addressDict = placemarks?[0].addressDictionary else {
        return
      }
      //print(UserDefaults.standard.object(forKey: "AppleLanguages") as! [String])

      // Print each key-value pair in a new row
      addressDict.forEach { print($0) }

      // Print fully formatted address
      if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
        //print(formattedAddress.joined(separator: ", "))
      }

      // Access each element manually
      if let province = addressDict["State"] as? String {
        //print(province)
        //MyLocationManager.currentProvince = province
        if let city = addressDict["Name"] as? String {
          //MyLocationManager.currentCity = city
          MyLocationManager.currentLocation = "\(province)\(city)"
          let locationGeted = Notification.Name.init(rawValue: "Location Update")
          NotificationCenter.default.post(name: locationGeted, object: nil)
          //print(MyLocationManager.myLocation)
        }
      } else {
        print("error")
      }
      //            if let city = addressDict["City"] as? String {
      //                print("city:\(city)")
      //            }
      //            if let zip = addressDict["ZIP"] as? String {
      //                print("zip:\(zip)")
      //            }
      //            if let country = addressDict["Country"] as? String {
      //                print(country)
      //            }
      //print(UserDefaults.standard.object(forKey: "AppleLanguages") as! [String])
      UserDefaults.standard.removeObject(forKey: "AppleLanguages")
      //print(UserDefaults.standard.object(forKey: "AppleLanguages") as! [String])
    })

  }

  override init() {
    super.init()
  }

}
