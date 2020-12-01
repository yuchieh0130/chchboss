//
//  addFriendViewController.swift
//  test
//
//  Created by Andrey C. on 2020/10/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class addFriendViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //搜尋好友
//        net.searchFriend(user_id: "3"){ (return_list) in
//            if let status_code = return_list?[0],
//                let friend = return_list?[1] as? [AnyObject]{
//                if status_code as! Int == 200{
//                    print(friend[0]) //friend[0]是那個人的名字！
//                }else{
//                    print("searchFriend statusCode \(status_code)")
//                }
//
//            }else{
//                print("searchFriend error")
//            }
//        }
        
        
        //加好友
//        net.addFriendRequest(friendId: "1"){ statusCode in
//            if statusCode == 200{
//                print("好友邀請送出")
//                //好友邀請送出看要做點啥，跳個通知之類
//            }else if statusCode == 400{
//                print("已經加過好友")
//                //已經加過好友看要做點啥，跳個通知之類
//            }else{
//                print("addFriendRequest error")
//            }
//        }
       
        
        navigationItem.title = "Add Friend"
        searchBar.delegate = self
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItems = [cancelBtn]
        
        searchBtn.isHidden = false
        addBtn.isHidden = true
        profileImage.isHidden = true
        nameLabel.isHidden = true
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        searchBtn.layer.cornerRadius = 10.0
        searchBtn.clipsToBounds = true
        
        profileImage.layer.cornerRadius = 0.5*profileImage.bounds.size.width
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        profileImage.clipsToBounds = true
        
        addBtn.layer.cornerRadius = 10.0
        addBtn.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.5)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)]
    }
    
    @IBAction func search(_ sender: Any) {
        searchBtn.isHidden = true
        addBtn.isHidden = false
        profileImage.isHidden = false
        nameLabel.isHidden = false
        searchBar.resignFirstResponder()
    }
    
    
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
