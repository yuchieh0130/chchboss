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
    @IBOutlet var emojiAngry: UIButton!
    @IBOutlet var emojiThumb: UIButton!
    @IBOutlet var emojiHeart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        labelView.layer.cornerRadius = 10.0
        labelView.clipsToBounds = true
        
        rankView.layer.cornerRadius = 10.0
        rankView.clipsToBounds = true
        
        winnerIcon.layer.cornerRadius = 0.5*winnerIcon.bounds.size.width
        winnerIcon.layer.borderWidth = 2
        winnerIcon.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        winnerIcon.clipsToBounds = true
        
        emojiAngry.layer.cornerRadius = 0.5*emojiAngry.bounds.size.width
        emojiAngry.clipsToBounds = true
        emojiThumb.layer.cornerRadius = 0.5*emojiThumb.bounds.size.width
        emojiThumb.clipsToBounds = true
        emojiHeart.layer.cornerRadius = 0.5*emojiHeart.bounds.size.width
        emojiHeart.clipsToBounds = true
        
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
        switch indexPath {
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
            cell.name.text = "Mo"
            cell.rank.text = "2"
            cell.percentage.text = "72%"
            cell.selectionStyle = .none
            return cell
        case [0,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
            cell.name.text = "WJ"
            cell.rank.text = "3"
            cell.percentage.text = "67%"
            cell.selectionStyle = .none
            return cell
        case [0,2]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
            cell.name.text = "Sherry"
            cell.rank.text = "4"
            cell.percentage.text = "38%"
            cell.selectionStyle = .none
            return cell
        case [0,3]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
            cell.name.text = "Vincent"
            cell.rank.text = "5"
            cell.percentage.text = "10%"
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rankTableViewCell", for: indexPath) as! rankTableViewCell
            cell.name.text = "CHCHBOSS"
            cell.rank.text = "2"
            cell.percentage.text = "70%"
            cell.selectionStyle = .none
            return cell
        }
    }
}
