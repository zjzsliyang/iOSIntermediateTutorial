//
//  ViewController.swift
//  3DTouch
//
//  Created by SnowCheng on 16/5/15.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabView = UITableView.init(frame: view.bounds, style: .grouped)
        tabView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tabView.delegate = self
        tabView.dataSource = self
        view.addSubview(tabView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
        MyNotification()
        
    }
    
    func MyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Tutorial"
        content.subtitle = "from TAC"
        content.body = " Notification triggered"
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "com.iyunxiao.-DTouch", content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }    

}

extension ViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "To TouchViewController"
        case 1:
            cell.textLabel?.text = "To DrawViewController"
        case 2:
            cell.textLabel?.text = "To PurchaseViewController"
        case 3:
            cell.textLabel?.text = "To Notebook"
        default:
            break
        }
        cell.accessoryType = .disclosureIndicator
        
        registerForPreviewing(with: self, sourceView: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case 0:
            navigationController?.pushViewController(ViewTouchController(), animated: true)
        case 1:
            navigationController?.pushViewController(DrawTouchController(), animated: true)
        case 2:
            performSegue(withIdentifier: "toPurchase", sender: self)
        case 3:
            performSegue(withIdentifier: "toNote", sender: self)
            
        default:
            break
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let cell = previewingContext.sourceView as? UITableViewCell else {
            return nil
        }
        
        switch cell.textLabel?.text ?? ""
        {
        case "0":
            let touchVC = ViewTouchController()
            touchVC.preferredContentSize = CGSize.init(width: 0, height: 500)
            return touchVC
        case "1":
            let drawTouchVC = DrawTouchController()
            drawTouchVC.preferredContentSize = CGSize.init(width: 50, height: 300)
            return drawTouchVC
        default:
            return nil
        }

    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
    
}
