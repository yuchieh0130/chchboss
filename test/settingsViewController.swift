//
//  settingsViewController.swift
//  test
//
//  Created by 王義甫 on 2020/6/29.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class settingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch  indexPath {
        case [0,0]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "changeUsernameCell", for: indexPath) as! changeUsernameCell
            return cell
        case [0,1]:
            let cell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell", for: indexPath) as! changePasswordCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editMyplaceCell", for: indexPath)
            return cell
        }
    }
}
