//
//  tabBarController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class tabBarController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
            super.viewDidLoad()
            self.delegate = self
            
            tabBar.items?[0].title = "Calendar"
            tabBar.items?[1].title = "Track"
            tabBar.items?[3].title = "Task"
            tabBar.items?[4].title = "Analysis"
            
        }
    //    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    //        print("select")
    //    }
    //    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    //        print("Selected view controller", viewController)
    //        print("index", tabBarController.selectedIndex )
    //    }
    //
    //    //MARK: UITabbar Delegate
    //    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    //      if viewController.isKind(of: actionViewController.self) {
    //         let vc =  actionViewController()
    //         vc.modalPresentationStyle = .overFullScreen
    //         self.present(vc, animated: true, completion: nil)
    //         return false
    //      }
    //      return true
    //    }
        
    }

