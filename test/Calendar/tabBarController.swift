//
//  tabBarController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class tabBarController: UITabBarController{
    override func viewDidLoad() {
        tabBar.items?[0].title = "Calendar"
        tabBar.items?[1].title = "Track"
        tabBar.items?[2].title = "Task"
    }
    
}
