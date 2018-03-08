//
//  AppDelegate.swift
//  3DTouch
//
//  Created by SnowCheng on 16/5/15.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let itemIcon1 = UIApplicationShortcutIcon.init(templateImageName: "AIcon")
        let item1 = UIApplicationShortcutItem.init(type: "type1", localizedTitle: "enterWithoutAlert", localizedSubtitle: "without an alert view", icon: itemIcon1, userInfo: nil)
        
        let itemIcon2 = UIApplicationShortcutIcon.init(templateImageName: "rightIcon")
        let item2 = UIApplicationShortcutItem.init(type: "type2", localizedTitle: "enterWithAlert", localizedSubtitle: "with an alert view", icon: itemIcon2, userInfo: nil)
        
        UIApplication.shared.shortcutItems = [item1, item2]
        
        completeIAPTransactions()
    
        //
        return true
}

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case "type1":
            print("type1__3DTouch")
        default:
            //弹框
            let alertVC = UIAlertController.init(title: "你好", message: "3DTouch", preferredStyle: UIAlertControllerStyle.alert)
            let act1 = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.destructive, handler: { (_) in })
            
            alertVC.addAction(act1)
            
            window?.rootViewController?.present(alertVC, animated: true, completion: nil)
        }
    }

    
    func completeIAPTransactions() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                // swiftlint:disable:next for_where
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("purchased: \(purchase.productId)")
                }
            }
        }
    }
    
    
    func MyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Tutorial"
        content.subtitle = "from TAC"
        content.body = " Notification triggered"
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // 4
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    

}

