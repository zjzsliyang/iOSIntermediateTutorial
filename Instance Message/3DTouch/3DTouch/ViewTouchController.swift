//
//  ViewTouchController.swift
//  3DTouch
//
//  Created by SnowCheng on 16/5/15.
//  Copyright © 2016年 SnowCheng. All rights reserved.
//

import UIKit

class ViewTouchController: UIViewController, UIViewControllerPreviewingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "touchVC"
        
        let bg = UIImageView()
        bg.frame = CGRect(x: 0, y: 0, width: view.bounds.maxX, height: view.bounds.maxY)
        bg.image = UIImage(named: "Background")
        view.addSubview(bg)
        
        let touchView = UIButton()
        touchView.setBackgroundImage(UIImage(named: "flower"), for: .normal)
        touchView.setTitle("TapTap", for: UIControlState())
        touchView.bounds = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        touchView.center = view.center
        
        let rectView = UIView()
        rectView.frame = CGRect.init(x: 50, y: 50, width: 50, height: 50)
        let rectBG = UIImageView()
        rectBG.frame = CGRect(x: 0, y: 0, width: rectView.bounds.maxX, height: rectView.bounds.maxY)
        rectView.addSubview(rectBG)
        
        
        view.addSubview(touchView)
//        touchView.addSubview(rectView)
        
        let VCPreviewing = registerForPreviewing(with: self, sourceView: touchView)
        VCPreviewing.sourceRect = rectView.frame
    }
    
    override var previewActionItems : [UIPreviewActionItem] {
        
        let item1 = UIPreviewAction.init(title: "item1", style: .destructive) { (_, _) in
            print("viewTouch__item1")
        }
        
        let item2 = UIPreviewAction.init(title: "item2", style: .default) { (_, _) in
            print("viewTouch__item2")
        }
        
        let item3 = UIPreviewAction.init(title: "item3", style: .selected) { (_, _) in
            print("viewTouch__item3")
        }
        
        return [item1, item2, item3]
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let drawVC = DrawTouchController()
        drawVC.preferredContentSize = CGSize.init(width: 150, height: 300)
        
        previewingContext.sourceRect = CGRect.init(x: 50, y: 50, width: 50, height: 50)
        
        return drawVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
        
    }
    
}
