//
//  rankViewController.swift
//  test
//
//  Created by Andrey C. on 2020/10/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class rankViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var labelView: UIView!
    @IBOutlet var rankView: UIView!
    @IBOutlet var exitBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var winnerIcon: UIImageView!
    @IBOutlet var winnerName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        labelView.layer.cornerRadius = 10.0
        labelView.clipsToBounds = true
        
        rankView.layer.cornerRadius = 10.0
        rankView.clipsToBounds = true
        
        exitBtn.backgroundColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        exitBtn.tintColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 1)
        exitBtn.layer.cornerRadius = 10.0
        exitBtn.clipsToBounds = true
        exitBtn.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }
    
    @objc func exit(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
        cell.name.text = "CHCHBOSS"
        cell.rank.text = "2"
        cell.percentage.text = "70%"
        cell.selectionStyle = .none
        return cell
    }
}
