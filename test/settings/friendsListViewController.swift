//
//  friendsListViewController.swift
//  test
//
//  Created by Andrey C. on 2020/10/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class friendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addFriendBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend(_:)))
        navigationItem.rightBarButtonItems = [addFriendBtn]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    @objc func addFriend(_ sender: Any){
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
            cell.friendName.text = "Vincent"
            return cell
        case [0,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
            cell.friendName.text = "Red Xin Rou"
            return cell
        case [0,2]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
            cell.friendName.text = "Mo"
            return cell
        case [0,3]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
            cell.friendName.text = "Sherry"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
            cell.friendName.text = "WJ"
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friendProfile", sender: self)
    }
}
