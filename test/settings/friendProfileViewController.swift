//
//  friendProfileViewController.swift
//  test
//
//  Created by Andrey C. on 2020/10/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class friendProfileViewController: UIViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var friendName: UILabel!
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var name: String?
    var like: Int32?
    var heart: Int32?
    var mad: Int32?
    
    @IBOutlet var emojiAngry: UIImageView!
    @IBOutlet var emojiThumb: UIImageView!
    @IBOutlet var emojiHeart: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var madLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = name,
           let like = like,
           let heart = heart,
           let mad = mad {
            friendName.text = name
            likeLabel.text = "x \(like)"
            heartLabel.text = "x \(heart)"
            madLabel.text = "x \(mad)"
        }
        
        friendName.layer.cornerRadius = 10.0
        friendName.clipsToBounds = true
        
        emojiAngry.layer.cornerRadius = 0.5*emojiAngry.bounds.size.width
        emojiAngry.clipsToBounds = true
        emojiThumb.layer.cornerRadius = 0.5*emojiThumb.bounds.size.width
        emojiThumb.clipsToBounds = true
        emojiHeart.layer.cornerRadius = 0.5*emojiHeart.bounds.size.width
        emojiHeart.clipsToBounds = true
        
        profileImage.layer.cornerRadius = 0.5*profileImage.bounds.size.width
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(red: 34/255, green: 45/255, blue: 101/255, alpha: 0.8).cgColor
        profileImage.clipsToBounds = true
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
}
