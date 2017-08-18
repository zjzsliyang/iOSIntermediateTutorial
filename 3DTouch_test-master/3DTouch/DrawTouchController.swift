//
//  DrawTouchController.swift
//  3DTouch
//
//  Created by SnowCheng on 16/5/15.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit
import UserNotifications

class DrawTouchController: UIViewController {
    
    let positionLable = UILabel()
    let forceLable = UILabel()
    let imageView = UIImageView()
    
    var lastPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.lightGray
        title = "drawVC"
        
        let bg = UIImageView()
        bg.frame = CGRect(x: 0, y: 0, width: view.bounds.maxX, height: view.bounds.maxY)
        bg.image = UIImage(named: "flower")
        view.addSubview(bg)
        
        positionLable.frame = CGRect.init(x: 0, y: 50, width: 200, height: 50)
        forceLable.frame = CGRect.init(x: 200, y: 50, width: 200, height: 50)
        imageView.frame = view.bounds
        
        view.addSubview(positionLable)
        view.addSubview(forceLable)
        view.addSubview(imageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first?.location(in: view) ?? CGPoint.zero
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first ?? UITouch()
        let currentPoint = touch.location(in: view) 
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        imageView.image?.draw(in: view.bounds)
        
        let path = UIBezierPath()
        path.move(to: lastPoint)
        path.addLine(to: currentPoint)
        path.lineWidth = touch.force * 5
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.stroke()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        positionLable.text = "x:\(currentPoint.x), y:\(currentPoint.y)"
        forceLable.text = "force: \(touch.force)"
        
        lastPoint = currentPoint
    }
    
    override var previewActionItems : [UIPreviewActionItem] {
        
        let item1 = UIPreviewAction.init(title: "item1", style: .destructive) { (_, _) in
            print("viewTouch__item1")
            let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            rootVC?.pushViewController(self, animated: true)
        }
        
        let item2 = UIPreviewAction.init(title: "item2", style: .default) { (_, _) in
            print("viewTouch__item2")
        }
        
        let item3 = UIPreviewAction.init(title: "item3", style: .selected) { (_, _) in
            print("viewTouch__item3")
        }
        
        let item4 = UIPreviewAction.init(title: "item4", style: .selected) { (_, _) in
            print("viewTouch__item3")
        }
        
        let item5 = UIPreviewAction.init(title: "item5", style: .selected) { (_, _) in
            print("viewTouch__item3")
        }
        
        let group1 = UIPreviewActionGroup.init(title: "group1", style: .destructive, actions: [item1, item2])
        
        let group2 = UIPreviewActionGroup.init(title: "group2", style: .default, actions: [item3, item4])
        
        let group3 = UIPreviewActionGroup.init(title: "group3", style: .selected, actions: [item5])
        
        return [group1, group2, group3]
    }
    

    
    
}
