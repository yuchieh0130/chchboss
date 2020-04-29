//
//  autoRecordViewController.swift
//  test
//
//  Created by 王義甫 on 2020/4/4.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class autoRecordViewController: UIViewController{
   
    
    @IBAction func btn(_ sender: Any) {
    }
    

    @IBOutlet var txt: UILabel!
    
    override func viewDidLoad() {
        title = "Track"
        let auc = DBManager.getInstance().getLocName()
        txt.text = "\(txt.text!) + \(auc!)\n"
        print(auc!)
    }
    
    
    
    
    
    
}
