//
//  MyLocationManager.swift
//  weather
//
//  Created by 罗忠金 on 18/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

class MyLocationManager:CLLocationManager,CLLocationManagerDelegate {
    
    
    static let locationShared = MyLocationManager()
    var flag:Bool = false
    
    var myCoordinate = CLLocationCoordinate2D()
    
    var test = CLLocation()
    
    var myLocations = [CLLocation]()
    
    static func myTest() -> Void {
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
        
        let coordinateNotification = Notification.Name.init("Get Coordinate")
        NotificationCenter.default.post(name: coordinateNotification, object: nil)
        
//        let notif = Notification.Name.init(rawValue: "Ladies And Gentlemen We Are Floating In Space")
//        NotificationCenter.default.post(name: notif, object: nil)
        
        
    }
    
    override init() {
        super.init()
        //MyLocationManager.myTest()
//        self.delegate = self
//        self.desiredAccuracy = kCLLocationAccuracyBest
//        self.requestWhenInUseAuthorization()
//        self.requestLocation()
        //print("hehe")
        //MyLocationManager.myTest()
    }
    
}
