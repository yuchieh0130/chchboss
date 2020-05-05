//
//  tabBarController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class tabBarController: UITabBarController, UITabBarControllerDelegate{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
            
        tabBar.items?[0].title = "Calendar"
        tabBar.items?[1].title = "Track"
        tabBar.items?[3].title = "Task"
        tabBar.items?[4].title = "Analysis"
        
        self.setupMiddleButton()
            
        }
    
      
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: 0, width: 50, height: 50))
        //button style
        middleBtn.setImage(UIImage.init(systemName:"plus.circle.fill"), for: .normal)
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.plusButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
       }

       // Menu Button Touch Action
       @objc func plusButtonAction(sender: UIButton) {
           actionSheet()
       }
    func actionSheet(){
        self.delegate = self
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
           
        // create an action
        let eventAction: UIAlertAction = UIAlertAction(title: "Add Event", style: .default) { action -> Void in
            print("Add Event")
            self.performSegue(withIdentifier: "addEvent", sender: nil)
            }
        
        let taskAction: UIAlertAction = UIAlertAction(title: "Add Task", style: .default) { action -> Void in
            print("Add Task")
            self.performSegue(withIdentifier: "addTask", sender: nil)
            }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(eventAction)
        actionSheetController.addAction(taskAction)
        actionSheetController.addAction(cancelAction)

        present(actionSheetController, animated: true) {
            print("option menu presented")
            }
                      
        }
    }

