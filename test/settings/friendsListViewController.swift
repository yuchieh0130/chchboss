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
    
    @objc func addFriend(_ sender: Any){
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friendProfile", sender: self)
    }
}
