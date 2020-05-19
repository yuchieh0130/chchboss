//
//  tabBarController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import Floaty

@available(iOS 13.0, *)
class tabBarController: UITabBarController, UITabBarControllerDelegate{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBarController?.delegate = self
            
        tabBar.items?[0].title = "Calendar"
        tabBar.items?[1].title = "Track"
        tabBar.items?[2].title = "Task"
        tabBar.items?[3].title = "Analysis"
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 70, y: self.view.frame.height - 150, width: 45, height: 45))
        floaty.buttonColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        floaty.plusColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        floaty.addItem(title:"Add Event", handler: {_ in
            self.performSegue(withIdentifier: "tabBarToEvent", sender: self)
        })
        floaty.addItem(title: "Add Task", handler: {_ in
            self.performSegue(withIdentifier: "tabBarToTask", sender: self)
        })
        floaty.openAnimationType = .slideUp
        self.view.addSubview(floaty)
        }
    
      
//    // TabBarButton – Setup Middle Button
//    func setupMiddleButton() {
//        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: 0, width: 50, height: 50))
//        //button style
//        middleBtn.setImage(UIImage.init(systemName:"plus.circle.fill"), for: .normal)
//        //add to the tabbar and add click event
//        self.tabBar.addSubview(middleBtn)
//        middleBtn.addTarget(self, action: #selector(self.plusButtonAction), for: .touchUpInside)
//        self.view.layoutIfNeeded()
//       }
//    
//    // Menu Button Touch Action
//    @objc func plusButtonAction(sender: UIButton){
//       }
//    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let tabBarIndex = tabBarController.viewControllers!.index(of: viewController)!
//        if  tabBarIndex == 2 {
//            let button1 = UIButton(type: .custom)
//            button1.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
//            button1.layer.cornerRadius = 0.5 * button1.bounds.size.width
//            button1.clipsToBounds = true
//            button1.addTarget(self, action: #selector(addEventBtn(_:)), for: .touchUpInside)
//            button1.backgroundColor = UIColor.systemBlue
//            button1.tintColor = UIColor.white
//            button1.setImage(UIImage.init(systemName: "calendar"), for: .normal)
//            
//
//            let button2 = UIButton()
//            button2.addTarget(self, action: #selector(addTaskBtn(_:)), for: .touchUpInside)
//            button2.backgroundColor = UIColor.systemBlue
//            button2.tintColor = UIColor.white
//            button2.setImage(UIImage.init(systemName: "doc.text"), for: .normal)
//            
//            let sv = UIStackView(arrangedSubviews: [button1,button2])
//            sv.distribution = .equalSpacing
//            let currentView = tabBarController.selectedViewController!.view!
//            sv.frame = CGRect(x: currentView.bounds.midX - 80, y: currentView.bounds.midY + 300, width: 160, height: 40)
//            currentView.addSubview(sv)
//            currentView.bringSubviewToFront(sv)
//            return false
//            }else{
//            return true
//            }
//    }
//    
//    @objc func addEventBtn(_ sender:UIButton) {
//        performSegue(withIdentifier: "addEvent", sender: nil)
//        }
//    @objc func addTaskBtn(_ sender:UIButton){
//        performSegue(withIdentifier: "addTask", sender: nil)
//    }
    
    
//    func actionSheet(){
//        self.delegate = self
//        // create an actionSheet
//        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
//
//        // create an action
//        let eventAction: UIAlertAction = UIAlertAction(title: "Add Event", style: .default) { action -> Void in
//            print("Add Event")
//            self.performSegue(withIdentifier: "addEvent", sender: nil)
//            }
//
//        let taskAction: UIAlertAction = UIAlertAction(title: "Add Task", style: .default) { action -> Void in
//            print("Add Task")
//            self.performSegue(withIdentifier: "addTask", sender: nil)
//            }
//
//        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
//
//        // add actions
//        actionSheetController.addAction(eventAction)
//        actionSheetController.addAction(taskAction)
//        actionSheetController.addAction(cancelAction)
//
//        present(actionSheetController, animated: true) {
//            print("option menu presented")
//            }
//        }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
//        let tabBarIndex = tabBarController.selectedIndex
//        if tabBarIndex == 0 {
//            print("Event was selected")
//            }else if tabBarIndex == 3{
//            print("Task was selected")
//            }
//        }
    
    
    }

