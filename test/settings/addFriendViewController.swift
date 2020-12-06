//
//  addFriendViewController.swift
//  test
//
//  Created by Andrey C. on 2020/10/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class addFriendViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cancelAddBtn: UIButton!
    
    var addName: String = ""
    var addId: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Friend"
        searchBar.delegate = self
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItems = [cancelBtn]
        
        searchBtn.isHidden = false
        addBtn.isHidden = true
        cancelAddBtn.isHidden = true
        profileImage.isHidden = true
        nameLabel.isHidden = true
        nameLabel.textAlignment = .center
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        searchBtn.layer.cornerRadius = 10.0
        searchBtn.clipsToBounds = true
        
        addBtn.layer.cornerRadius = 10.0
        addBtn.clipsToBounds = true
        
        cancelAddBtn.layer.cornerRadius = 10.0
        cancelAddBtn.clipsToBounds = true
        
        nameLabel.text = addName
        
        profileImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(140)
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar).offset(50)
        }
        //profileImage.layer.cornerRadius = 0.5*profileImage.bounds.size.width
        profileImage.layer.cornerRadius = 70
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        profileImage.clipsToBounds = true
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImage.snp.bottom).offset(40)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.5)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 218/255, blue: 119/255, alpha: 1)]
    }
    
    @IBAction func addFriend(_ sender: Any) {
        net.addFriendRequest(friendId: "\(addId!)"){ statusCode in
            if statusCode == 200 {
                print("好友邀請送出")
                //好友邀請送出看要做點啥，跳個通知之類
                self.friendRequestSent()
                
            }else if statusCode == 400{
                print("已經加過好友")
                //已經加過好友看要做點啥，跳個通知之類
                self.friendAlreadyAdded()
            }else{
                print("addFriendRequest error")
            }
        }
    }
    
    @IBAction func search(_ sender: Any) {
        net.searchFriend(user_id: searchBar.text ?? ""){ (return_list) in
            if let status_code = return_list?[0],
                let friend = return_list?[1] as? [[AnyObject]]{
                if status_code as! Int == 200{
                    self.showResult()
                    self.addName = friend[0][0] as! String
                    self.addId = friend[0][1] as! Int
                    //self.addId = Int(self.searchBar.text ?? "0")
                    print(friend) //friend[0]是那個人的名字！
                }else{
                    print("searchFriend statusCode \(status_code)")
                }

            }else{
                print("searchFriend error")
                self.notFound()
            }
        }
    }
    
    func showResult() {
        DispatchQueue.main.async {
            self.profileImage.image = UIImage(named: "user\(self.searchBar.text ?? "100")")
            self.searchBtn.isHidden = true
            self.cancelAddBtn.isHidden = false
            self.addBtn.isHidden = false
            self.profileImage.isHidden = false
            self.nameLabel.isHidden = false
            self.nameLabel.text = self.addName
            self.searchBar.resignFirstResponder()
        }
    }
    
    func notFound() {
        DispatchQueue.main.async {
            self.nameLabel.isHidden = false
            self.nameLabel.text = "User not found."
        }
    }
    
    func friendRequestSent() {
        DispatchQueue.main.async {
            self.nameLabel.isHidden = false
            self.nameLabel.text = "Request sent."
            self.cancelAddBtn.isHidden = false
            self.cancelAddBtn.setTitle("OK", for: .normal)
            self.addBtn.isHidden = true
        }
    }
    
    func friendAlreadyAdded() {
        DispatchQueue.main.async {
            self.nameLabel.isHidden = false
            self.nameLabel.adjustsFontSizeToFitWidth = true
            self.nameLabel.text = "User is already your friend."
            self.cancelAddBtn.isHidden = false
            self.cancelAddBtn.setTitle("OK", for: .normal)
            self.addBtn.isHidden = true
        }
    }
    
    @IBAction func cancelAdd(_ sender: Any) {
        searchBtn.isHidden = false
        cancelAddBtn.isHidden = true
        addBtn.isHidden = true
        profileImage.isHidden = true
        nameLabel.isHidden = true
        searchBar.text = ""
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
