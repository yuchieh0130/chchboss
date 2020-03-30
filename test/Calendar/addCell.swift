//
//  addSwitchCell.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/26.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

//cells' class in addViewController tableView
class addCell: UITableViewCell{
}

class nameCell: UITableViewCell {
    
    @IBOutlet var txtEventName: UITextField!
    
}

class startCell: UITableViewCell {
    @IBOutlet var txtStartDate: UILabel!
    
}

class endCell: UITableViewCell {
    @IBOutlet var txtEndDate: UILabel!
}

class allDayCell: UITableViewCell {
    
}

class autoTimeCell: UITableViewCell {
    @IBOutlet var txtAutoStart: UILabel!
    @IBOutlet var txtAutoEnd: UILabel!

}

class autoCategoryCell: UITableViewCell {
    @IBOutlet var txtAutoCategory: UILabel!
}

class autoLocationCell: UITableViewCell {
    @IBOutlet weak var txtLocation: UILabel!
}

class taskTimeCell: UITableViewCell {
      
      @IBOutlet var txtTaskTime: UILabel!
}

