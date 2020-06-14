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
import FanMenu
import Macaw

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
        tabBar.items?[3].title = "Task"
        tabBar.items?[4].title = "Analysis"
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width/2 - 22, y: self.view.frame.height - 77, width: 45, height: 45))
        floaty.buttonColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        floaty.plusColor = UIColor.white
        floaty.itemButtonColor = UIColor(red: 190/255, green: 155/255, blue: 116/255, alpha: 0.8)
        floaty.addItem("", icon: UIImage(named: "task"), handler: {_ in
            self.performSegue(withIdentifier: "tabBarToTask", sender: self)
        })
        floaty.addItem("", icon: UIImage(named: "calendar"), handler: {_ in
            self.performSegue(withIdentifier: "tabBarToEvent", sender: self)
        })
        floaty.openAnimationType = .slideUp
//        floaty.isDraggable = false
        floaty.hasShadow = false
        floaty.autoCloseOnTap = true
//        floaty.paddingY += self.tabBar.frame.size.height
//        floaty.paddingX += self.tabBar.frame.midX
        self.view.addSubview(floaty)
        
        // 99 152
        let fanMenu = FanMenu(frame: CGRect(x: self.view.frame.width/2 - 99, y: self.view.frame.height - 100, width: 200, height: 200))
        fanMenu.button = FanMenuButton(
            id: "main", image: UIImage(named: "Plus"), color: Color(val: 0xF7C758))
        fanMenu.items = [
            FanMenuButton(id: "calendar", image: UIImage(named: "calendar"), color: Color(val: 0xBE9B74)),
            FanMenuButton(id: "task", image: UIImage(named: "task"), color: Color(val: 0xBE9B74)),
            ]
        
        // call before animation
        fanMenu.onItemDidClick = { button in
                if let button = fanMenu.button {
                if button.id == "calendar"{
                    self.performSegue(withIdentifier: "tabBarToEvent", sender: self)
                }else if button.id == "task"{
                    self.performSegue(withIdentifier: "tabBarToTask", sender: self)
                }
            }
            }
        
        // call after animation
        fanMenu.onItemWillClick = { button in
            if let button = fanMenu.button {
                if button.id == "calendar"{
                    self.performSegue(withIdentifier: "tabBarToEvent", sender: self)
                }else if button.id == "task"{
                    self.performSegue(withIdentifier: "tabBarToTask", sender: self)
                }
            }
            print("ItemWillClick: \(button.id)")
            }
        fanMenu.menuRadius = 70.0  //menu radius
        fanMenu.duration = 0.2
        fanMenu.delay = 0.05
        fanMenu.interval = (Double.pi + Double.pi/4, Double.pi + 3 * Double.pi/4)
        fanMenu.radius = 25.0  //button radius
        fanMenu.backgroundColor = .clear
        //self.view.addSubview(fanMenu)
        
        }
    
    //讓你按中間的tab bar item 不會跑出view controller
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: middleViewController.self) {
         let vc =  middleViewController()
         vc.modalPresentationStyle = .overFullScreen
         self.present(vc, animated: true, completion: nil)
         return false
      }
      return true
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

