//
//  rootView.swift
//  SpecularLight
//
//  Created by Lin on 2017/8/16.
//  Copyright © 2017年 BurtK. All rights reserved.
//

import Foundation

class rootViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let initIdentifier = "Cell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: initIdentifier)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Metal Demo"
            break
        case 1:
            cell.textLabel?.text = "OpenGl ES Demo"
            break
        case 2:
            cell.textLabel?.text = "CoreAudio Demo"
            break
        default:
            print("cell generated error!")
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "Metal", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "OpenGL", sender: self)
            break
        default:
            self.performSegue(withIdentifier: "CoreAudio", sender: self)
            break
        }
        
    }
    
    
}
