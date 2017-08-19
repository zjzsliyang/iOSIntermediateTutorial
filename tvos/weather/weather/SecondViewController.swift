//
//  SecondViewController.swift
//  weather
//
//  Created by 罗忠金 on 14/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        print(MyLocationManager.locationShared.myCoordinate.latitude)
//        print(MyLocationManager.locationShared.myCoordinate.longitude)
//        print(MyLocationManager.locationShared.myCoordinate.latitude)
//        print(MyLocationManager.locationShared.myCoordinate.longitude)
        let changeCity = Notification.Name.init(rawValue: "Change City")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CurrentWeatherViewController.sup),
                                               name: changeCity,
                                               object: nil)
        
    }
    
    @objc func sup(notification: Notification) {
        print("Change City")
//        print(MyLocationManager.locationShared.myCoordinate.latitude)
//        print(MyLocationManager.locationShared.myCoordinate.longitude)
//        print("gaigaigai")
        //mylabel.text = "\(MyLocationManager.locationShared.myCoordinate.latitude)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

