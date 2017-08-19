//
//  currentWeatherViewController.swift
//  weather
//
//  Created by 罗忠金 on 14/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit
import CoreLocation
//添加属性到属性检查器
@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
        
        
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

class CurrentWeatherViewController: UIViewController {
    @IBOutlet weak var myview: UIView!
    
    
    @IBOutlet weak var mylabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyLocationManager.myTest()
    
        let coordinateNotification = Notification.Name.init(rawValue: "Get Coordinate")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CurrentWeatherViewController.sup),
                                               name: coordinateNotification,
                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(CurrentWeatherViewController.sup),
//                                               name: notif,
//                                               object: nil)
    }
    
    @objc func sup(notification: Notification) {
        print("Get Coordinate")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonPress(_ sender: Any) {
        //print(MyLocationManager.locationShared.myCoordinate.latitude)
        //print(MyLocationManager.locationShared.myCoordinate.longitude)
        let changeCity = Notification.Name.init(rawValue: "Change City")
        NotificationCenter.default.post(name: changeCity, object: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
