//
//  analysisTableViewCell.swift
//  test
//
//  Created by 王義甫 on 2020/8/23.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class analysisTableViewCell: UITableViewCell {
    @IBOutlet var timeLabel: UILabel!
}

class combineChartTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
}

class rankTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var rank: UILabel!
    @IBOutlet var percentage: UILabel!
}
