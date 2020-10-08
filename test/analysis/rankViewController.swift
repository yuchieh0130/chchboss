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
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
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
    
    @IBAction func swipeDownGesture(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == UIGestureRecognizer.State.began{
            initialTouchPoint = touchPoint
        }else if sender.state == UIGestureRecognizer.State.changed{
            if touchPoint.y - initialTouchPoint.y > 0{
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
            }
        }else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled{
            if touchPoint.y - initialTouchPoint.y > 100{
                self.dismiss(animated: true, completion: nil)
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                })
            }
        }
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
