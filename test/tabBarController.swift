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
import HealthKit

class tabBarController: UITabBarController, UITabBarControllerDelegate{

//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//    }
    
    let user = UserController()
    let networkController = NetworkController()
    
    let date: Date = Date()
    let dateFormatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadAndDisplayMostRecentSleepAnalysis()
        
        dateFormatter.dateFormat = "yyyy/MM/dddd HH:mm"
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        
        
//        self.delegate = self
        self.tabBarController?.delegate = self
            
        tabBar.items?[0].title = "Calendar"
        tabBar.items?[1].title = "Task"
        tabBar.items?[2].title = "Analysis"
        tabBar.items?[3].title = "Settings"
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 67, y: self.view.frame.height - 145, width: 45, height: 45))
        floaty.buttonColor = UIColor(red: 247/255, green: 199/255, blue: 88/255, alpha: 1)
        floaty.plusColor = UIColor.white
        floaty.itemButtonColor = UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
        floaty.itemTitleColor =  UIColor(red: 67/255, green: 76/255, blue: 123/255, alpha: 1)
//        UIColor(red: 190/255, green: 155/255, blue: 116/255, alpha: 1)
        floaty.overlayColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        floaty.itemShadowColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        if #available(iOS 13.0, *) {
            floaty.addItem("Add Task", icon: UIImage(systemName: "doc.text"), handler: {_ in
                self.performSegue(withIdentifier: "tabBarAddTask", sender: self)
            })
            floaty.addItem("Add Event", icon: UIImage(systemName: "calendar"), handler: {_ in
                self.performSegue(withIdentifier: "tabBarAddEvent", sender: self)
            })
        } else {
            floaty.addItem("Add Task", icon: UIImage(named: "task"), handler: {_ in
                self.performSegue(withIdentifier: "tabBarAddTask", sender: self)
            })
            floaty.addItem("Add Event", icon: UIImage(named: "calendar"), handler: {_ in
                self.performSegue(withIdentifier: "tabBarAddEvent", sender: self)
            })
        }
        floaty.translatesAutoresizingMaskIntoConstraints = false
        floaty.openAnimationType = .slideUp
        floaty.isDraggable = true
        floaty.hasShadow = false
        floaty.autoCloseOnTap = true
//        self.view.addSubview(floaty)
//        
//        let tabBarIndex = tabBarController?.selectedIndex
//        if tabBarIndex == 0{
//            floaty.isHidden = true
//        }else if tabBarIndex == 1{
//            floaty.isHidden = true
//        }else if tabBarIndex == 2{
//            floaty.isHidden = true
//        }else if tabBarIndex == 3{
//            floaty.isHidden = true
//        }
        }
    
    public func loadAndDisplayMostRecentSleepAnalysis() {
        guard let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
            print("Sleep Analysis Sample Type is no longer available in HealthKit")
            return
        }

        UserController.getCategoryTypeData(for: sleepAnalysisType) {(sample, error) in
            if (sample != nil){
                print("Got Sleep")
            }else{
                print("Sleep Not Found ")
            }
            guard let sample = sample else {

                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }

            for each in sample {
                if let data = each as? HKCategorySample {
                    print(data)
                    let inBed = data.value == HKCategoryValueSleepAnalysis.inBed.rawValue
                    print("inbed:", inBed)
                    let asleep = data.value == HKCategoryValueSleepAnalysis.asleep.rawValue
                    print("asleep:", asleep)
                    let startDate = data.startDate
                    let startDateFormatString: String = self.dateFormatter.string(from: startDate)
                    print("startDate:", startDateFormatString)
                    let endDate = data.endDate
                    let endDateFormatString: String = self.dateFormatter.string(from: endDate)
                    print("endDate:", endDateFormatString)

                    let now = NSDate()
                    let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
                    let weekAgo = nowTimeStamp - 604800
                    //604800 one week
                    //86400 one day

                    let startDateStamp: TimeInterval = startDate.timeIntervalSince1970
                    let endDateStamp: TimeInterval = endDate.timeIntervalSince1970
//                    if (startDateStamp > weekAgo && endDateStamp > weekAgo) {
//                        let startDateStampString = String(startDateStamp)
//                        let endDateStampString = String(endDateStamp)

//                        self.networkController.postSleepData(inBed: inBed, startDate: startDateStampString, endDate: endDateStampString, session_id: self.user.session_id!) {
//                            (status_code) in
//                                if (status_code != nil) {
//                                    print(status_code!)
//                                }
//                        }
//                    }
                }
            }
            let lastSample = sample.last as? HKCategorySample
            let inBed = lastSample!.value == HKCategoryValueSleepAnalysis.inBed.rawValue
            let asleep = lastSample!.value == HKCategoryValueSleepAnalysis.asleep.rawValue
            let sleepStartDate = lastSample!.startDate
            let sleepEndDate = lastSample!.endDate
            self.user.inBedTime = inBed
            self.user.asleepTime = asleep
            self.user.sleepStart = sleepStartDate
            self.user.sleepEnd = sleepEndDate
        }
    }
    
    private func displayAlert(for error: Error) {

        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "O.K.",
                                      style: .default,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    //讓你按中間的tab bar item 不會跑出view controller
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController.isKind(of: middleViewController.self) {
//         let vc =  middleViewController()
//         vc.modalPresentationStyle = .overFullScreen
//         self.present(vc, animated: true, completion: nil)
//         return false
//      }
//      return true
//    }
    
      
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

