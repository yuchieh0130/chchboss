//
//  TableView Controller.swift
//  test
//
//  Created by 王義甫 on 2020/3/25.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class reminderTableViewController: UITableViewController {
    
    let datasource = ["At time of event", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before", "Custom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reminderTableViewCell") as! reminderTableViewCell
        reminderTableViewCell.reminderTime.text = datasource[indexPath.row]
        return reminderTableViewCell
    }
    
    
    
    
}
 
