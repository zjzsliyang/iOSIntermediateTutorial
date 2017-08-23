//
//  SecondViewController.swift
//  Weather
//
//  Created by 罗忠金 on 14/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
  
  @IBOutlet var rootView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MyWeatherManager.setWeatherForecastInfo(updateUI: { (finalDataArray) in
      self.upDateUI(finalDataArray: finalDataArray)
    })
    
    //        let locationGeted = Notification.Name.init(rawValue: "Location Update")
    //        NotificationCenter.default.addObserver(forName: locationGeted, object: nil, queue: nil){(notification) in
    //                print("hehe")
    //        }
    
    let forecastNotification = Notification.Name.init(rawValue: "ForeCast View Update")
    NotificationCenter.default.addObserver(forName: forecastNotification, object: nil, queue: nil) { (notification) in
      
      MyWeatherManager.setWeatherForecastInfo(updateUI: { (finalDataArray) in
        self.upDateUI(finalDataArray: finalDataArray)
      })
    }
  }
  
  
  func upDateUI(finalDataArray: [[String: String]]) -> Void {
    for i in 1...7 {
      self.upDate(finalDataArray: finalDataArray, index: i)
    }
  }
  
  func upDate(finalDataArray: [[String: String]], index: Int) {
    DispatchQueue.main.async() {
      (self.rootView.subviews[index].subviews[0] as! UILabel).text = finalDataArray[index - 1]["date"]
      (self.rootView.subviews[index].subviews[1] as! UIImageView).image = UIImage(named: finalDataArray[index - 1]["code_day"]!)
      (self.rootView.subviews[index].subviews[2] as! UILabel).text = finalDataArray[index - 1]["text_day"]
      (self.rootView.subviews[index].subviews[3] as! UILabel).text =
        finalDataArray[index - 1]["high"]! + "℃" + "~" + finalDataArray[index - 1]["low"]! + "℃"
      (self.rootView.subviews[index].subviews[5] as! UILabel).text = finalDataArray[index - 1]["sunrise"]
      (self.rootView.subviews[index].subviews[7] as! UILabel).text = finalDataArray[index - 1]["sunset"]
      
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

