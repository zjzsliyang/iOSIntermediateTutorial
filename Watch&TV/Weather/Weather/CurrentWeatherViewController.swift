//
//  currentWeatherViewController.swift
//  Weather
//
//  Created by 罗忠金 on 14/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit
import CoreLocation
//添加属性到属性检查器
@IBDesignable extension UIView {
  @IBInspectable var borderColor: UIColor? {
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
  @IBInspectable var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }
  @IBInspectable var cornerRadius: CGFloat {
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
  
  @IBOutlet weak var ui_textField: UITextField!
  @IBOutlet weak var myview: UIView!
  
  @IBOutlet weak var ui_temperature: UILabel!
  @IBOutlet weak var ui_code: UIImageView!
  @IBOutlet weak var ui_text: UILabel!
  @IBOutlet weak var ui_sunrise: UILabel!
  @IBOutlet weak var ui_sunset: UILabel!
  @IBOutlet weak var ui_moonrise: UILabel!
  @IBOutlet weak var ui_moonset: UILabel!
  @IBOutlet weak var ui_quality: UILabel!
  @IBOutlet weak var ui_pm25: UILabel!
  @IBOutlet weak var ui_suggestion: UITextView!
  
  
  @IBOutlet weak var mylabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MyWeatherManager.initWeatherBasicInfo(updateUI: { (finalData) in
      self.updateUI(finalData: finalData)
    })
    
    let currentNotification = Notification.Name.init(rawValue: "Current View Update")
    NotificationCenter.default.addObserver(forName: currentNotification, object: nil, queue: nil) { (notification) in
      MyWeatherManager.setWeatherBasicInfo(updateUI: { (finalData) in
        self.updateUI(finalData: finalData)
      })
    }
  }
  
  func updateUI(finalData: [String: String]) -> Void {
    let temperature = finalData["temperature"]
    let code = finalData["code"]
    let text = finalData["text"]
    
    let sunrise = finalData["sunrise"]
    let sunset = finalData["sunset"]
    let moonrise = finalData["moonrise"]
    let moonset = finalData["moonset"]
    
    let quality = finalData["quality"]
    let pm25 = finalData["pm25"]
    let suggestion = finalData["details"]
    
    
    DispatchQueue.main.async() {
      self.ui_temperature.text = temperature! + "℃"
      self.ui_code.image = UIImage(named: code!)
      self.ui_text.text = text
      self.ui_sunrise.text = sunrise
      self.ui_sunset.text = sunset
      self.ui_moonrise.text = moonrise
      self.ui_moonset.text = moonset
      self.ui_quality.text = quality
      self.ui_pm25.text = pm25
      self.ui_suggestion.text = suggestion
    }
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func searchButtonPress(_ sender: Any) {
    
    
    let searchText = ui_textField.text as! String
    if (searchText != "" && searchText != MyLocationManager.currentLocation) {
      
      MyLocationManager.setCurrentLocation(current: searchText)
      let currentNotification = Notification.Name.init(rawValue: "Current View Update")
      NotificationCenter.default.post(name: currentNotification, object: nil)
      
      let forecastNotification = Notification.Name.init(rawValue: "ForeCast View Update")
      NotificationCenter.default.post(name: forecastNotification, object: nil)

      let chartNotification = Notification.Name.init(rawValue: "Chart View Update")
      NotificationCenter.default.post(name: chartNotification, object: nil)
      
    }
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
