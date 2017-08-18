//
//  MessageViewController.swift
//  Texcoder
//
//  Created by Nishanth P on 1/7/17.
//  Copyright © 2017 Nishapp. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messTableView: UITableView!

    var messages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

               // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        message {
            (messages) in
            self.messages = messages
            self.messTableView.reloadData()

        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel!.font = UIFont(name: "HelveticaNeue-light", size: 15)
        cell.textLabel!.text = messages[indexPath.row]
        cell.backgroundColor = UIColor.clear

        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            nsdefaults.set(messages, forKey:"textMess")

        } else if editingStyle == .insert {

        }
    }

    func message(completion:(_ messages: [String]) -> Void) {
        var array: [String] = [String]()
        if let items = nsdefaults.object(forKey:"textMess") as? [String] {
            for item in items {
            array.append(item)
            }
        }
        completion(array)
    }

}
