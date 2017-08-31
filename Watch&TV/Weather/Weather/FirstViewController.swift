//
//  FirstViewController.swift
//  Weather
//
//  Created by 罗忠金 on 14/08/2017.
//  Copyright © 2017 tongjiappleclub. All rights reserved.
//

import UIKit
import SwiftCharts

class FirstViewController: UIViewController {
    
    @IBOutlet weak var fisrtContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fisrtContainerView.isHidden = false
        secondContainerView.isHidden = true
    }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            fisrtContainerView.isHidden = false
            secondContainerView.isHidden = true
        case 1:
            fisrtContainerView.isHidden = true
            secondContainerView.isHidden = false
        default:
            break;
        }
    }
    
}

