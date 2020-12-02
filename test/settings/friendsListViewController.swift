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
    
    let net = NetworkController()
    
    let headerTitles = ["", "Pending Friends"]
    var listToRefresh : [FriendModel] = []
    
    var showCheckedFriends: [FriendModel]?
    var showUncheckedFriends: [FriendModel]?
    
    var dosthFriend: FriendModel?
    
//    @IBAction func deleteFriendBtn(_ sender: Any) {
//        net.deleteFriend(friendId: "0") {
//            (status_code) in
//            if (status_code != nil) {
//                print("deleteFriend\(status_code!)")
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addFriendBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend(_:)))
        navigationItem.rightBarButtonItems = [addFriendBtn]
        
        refreshFriend() //refresh DB friendList table
        
    }
    
    func getFriend(){
        showCheckedFriends = []
        showUncheckedFriends = []
        if DBManager.getInstance().getCheckedFriendList() != nil{
            showCheckedFriends = DBManager.getInstance().getCheckedFriendList()
        }else{
            showCheckedFriends = [FriendModel]()
        }
        
        if DBManager.getInstance().getUncheckedFriendList() != nil{
            showUncheckedFriends = DBManager.getInstance().getUncheckedFriendList()
        }else{
            showUncheckedFriends = [FriendModel]()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    @objc func addFriend(_ sender: Any){
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    
    func refreshFriend(){
        net.searchFriendList{ (return_list) in
            if let status_code = return_list?[0],
                let confirm = return_list?[1] as? [[AnyObject]],
                let unconfirm = return_list?[2] as? [[AnyObject]]{
                if status_code as! Int == 200{
                    //print("confirm Friends: \(confirm)")
                    if confirm.count>0 {
                        for i in 0...confirm.count-1{
                            let friend = FriendModel(friendId: confirm[i][0] as! Int32, name: confirm[i][1] as! String, like: confirm[i][2] as! Int32, heart: confirm[i][3] as! Int32, mad: confirm[i][4] as! Int32, isChecked: true)
                            self.listToRefresh.append(friend)
                        }
                    }
                    //print("unconfirm Friends: \(unconfirm)")
                    if unconfirm.count>0{
                        for i in 0...unconfirm.count-1{
                            let friend = FriendModel(friendId: unconfirm[i][0] as! Int32, name: unconfirm[i][1] as! String, like: 0, heart: 0, mad: 0, isChecked: false)
                            self.listToRefresh.append(friend)
                        }
                    }
                    DBManager.getInstance().refreshFriendList(self.listToRefresh)
                    self.getFriend()
                }else{
                    print("searchFriendList \(status_code)")
                    self.getFriend()
                }
            }else{
                print("searchFriendList error")
                self.getFriend()
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 2
        if showUncheckedFriends?.count == 0{ return 1 }else{ return 2}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if section == 0{
            rowCount = showCheckedFriends?.count ?? 0
        }else if section == 1{
            rowCount = showUncheckedFriends?.count ?? 0
        }
        return rowCount
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
        let pendingCell = tableView.dequeueReusableCell(withIdentifier: "pendingFriendListCell", for: indexPath) as! pendingFriendListCell
        //            cell.pendingFriendName.text = "Benson"
        //            return cell
        //print(indexPath[0])
        if indexPath[0] == 0 {
            let friend = self.showCheckedFriends![indexPath.row]
            cell.friendName.text = friend.name
            return cell
        } else {
            let friend = self.showUncheckedFriends![indexPath.row]
            pendingCell.pendingFriendName.text = friend.name
            pendingCell.confirmBtn.addTarget(self,
                                             action: #selector(didPressConfirmBtn(_:)),
                                             for: .touchUpInside)
            pendingCell.deleteBtn.addTarget(self,
                                            action: #selector(didPressDeleteBtn(_:)),
                                            for: .touchUpInside)
            dosthFriend = friend
            return pendingCell
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? friendProfileViewController
        let indexPath = self.tableView.indexPathForSelectedRow
        controller?.frinedId = showCheckedFriends![indexPath!.row].friendId ?? 0
        controller?.name = showCheckedFriends![indexPath!.row].name
        controller?.like  = showCheckedFriends![indexPath!.row].like
        controller?.heart = showCheckedFriends![indexPath!.row].heart
        controller?.mad = showCheckedFriends![indexPath!.row].mad
    }
    
    @objc func didPressConfirmBtn(_ sender: UITapGestureRecognizer? = nil) {
        let friendId = "\(dosthFriend!.friendId!)"
        net.insertFriend(friendId: friendId) {
            (status_code) in
            if (status_code != nil) {
                print("confirmFriend\(status_code!)")
            }
        }
        showUncheckedFriends = showUncheckedFriends?.filter{ $0.friendId != dosthFriend!.friendId! }
        showCheckedFriends?.append(dosthFriend!)
        tableView.reloadData()
    }
    
    @objc func didPressDeleteBtn(_ sender: UITapGestureRecognizer? = nil) {
        let friendId = "\(dosthFriend!.friendId!)"
        net.deleteFriend(friendId: friendId) {
            (status_code) in
            if (status_code != nil) {
                print("deleteFriend\(status_code!)")
            }
        }
        showUncheckedFriends = showUncheckedFriends?.filter{ $0.friendId != dosthFriend!.friendId! }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friendProfile", sender: self)
    }
    
}
