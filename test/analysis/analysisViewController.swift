//
//  analysisViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/28.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import Floaty

class analysisViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analysis"
        
        let floaty = Floaty(frame: CGRect(x: self.view.frame.width - 70, y: self.view.frame.height - 150, width: 45, height: 45))
        floaty.addItem(title:"Add Event", handler: {_ in
            self.performSegue(withIdentifier: "anaToEvent", sender: self)
        })
        floaty.addItem(title: "Add Task", handler: {_ in
            self.performSegue(withIdentifier: "anaToTask", sender: self)
        })
        self.view.addSubview(floaty)
    }
}
