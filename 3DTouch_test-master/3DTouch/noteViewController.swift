//
//  noteViewController.swift
//  3DTouch
//
//  Created by mac on 2017/8/18.
//  Copyright © 2017年 SnowCheng. All rights reserved.
//

import UIKit

class noteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    private var conCount = 0
    private var titleArr:Array<String> = []
    private var conArray:Array<String> = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewDidLoad() {
    }
    
    func getData() -> Int{
        //local
        var data = Data()
        let url = URL(string: "http://127.0.0.1:8888/api")
        do{
            data = try Data(contentsOf: url!)
        }catch let err as NSError{
            print("error: ", err)
        }
        do{
            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            if dict!["status"] as! Int == 200{
                let arr:Array<Dictionary<String, String>> = dict!["data"] as! Array<Dictionary<String, String>>
                    conCount = arr.count
                    for i in arr{
                        titleArr.append(i["title"]!)
                        conArray.append(i["content"]!)
                    }
            }
        }catch let err as NSError{
            print("error: ", err)
        }
        return conCount
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData()+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier="Cells";
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        
        if indexPath.row < conCount{
            cell.textLabel?.text = titleArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            
            cell.detailTextLabel?.numberOfLines = 3
            cell.detailTextLabel?.text = conArray[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }else{
            cell.textLabel?.text = "New Note"
            cell.textLabel?.textAlignment = .center
        }
        
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == conCount - 1  {
            performSegue(withIdentifier: "toEnter", sender: self)
        }
    }
    
}
