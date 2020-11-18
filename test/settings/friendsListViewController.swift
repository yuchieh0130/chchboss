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
    let headerTitles = ["", "Pending Friends"]
    
    var showAllFriends: [FriendModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addFriendBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend(_:)))
        navigationItem.rightBarButtonItems = [addFriendBtn]
        
        
        
        if DBManager.getInstance().getFriendList() != nil{
            showAllFriends = DBManager.getInstance().getFriendList()
        }else{
            showAllFriends = [FriendModel]()
        }
        
        print("rr",DBManager.getInstance().getFriendList())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    @objc func addFriend(_ sender: Any){
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var rowCount = 0
//        if section == 0{
//            rowCount = 5
//        }else if section == 1{
//            rowCount = 2
//        }
        return showAllFriends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        if section == 1{
//            headerView.backgroundColor = UIColor.white
//        }
//        return headerView
//
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var rowHeight = 0
        if section == 1{
            rowHeight = 40
        }
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        if section == 1{
            view.tintColor = UIColor(red: 148/255, green: 148/255, blue: 149/255, alpha: 0.3)
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
        let friend = self.showAllFriends![indexPath.row]
        
//        cell.friendName.text = friend.friendId
        
 //       cell?.detailTextLabel?.text = "\(distance) km \(subAdministrativeArea) \(locality) "
//        cell?.detailTextLabel?.isHidden = false
        
        return cell
        
//        switch indexPath {
//        case [0,0]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
//            cell.friendName.text = "Vincent"
//            return cell
//        case [0,1]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
//            cell.friendName.text = "Red Xin Rou"
//            return cell
//        case [0,2]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
//            cell.friendName.text = "Mo"
//            return cell
//        case [0,3]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
//            cell.friendName.text = "Sherry"
//            return cell
//        case [0,4]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
//            cell.friendName.text = "WJ"
//            return cell
//        case [1,0]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingFriendListCell", for: indexPath) as! pendingFriendListCell
//            cell.pendingFriendName.text = "Jessica"
//            return cell
//        case [1,1]:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingFriendListCell", for: indexPath) as! pendingFriendListCell
//            cell.pendingFriendName.text = "Benson"
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! friendListCell
//            cell.friendName.text = "WJ"
//            return cell
//        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friendProfile", sender: self)
    }
}
