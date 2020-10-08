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
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
