//
//  taskTableViewCell.swift
//  test
//
//  Created by 王義甫 on 2020/4/12.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import UIKit

class taskTableViewCell: UITableViewCell {
    
    @IBOutlet var taskName: UILabel!
    @IBOutlet var addTaskTime: UILabel!
    @IBOutlet var taskShowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
