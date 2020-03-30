//
//  ScheduleTableViewCell.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/16.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import UIKit

class eventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventColor: UIView!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
