//
//  settingsTableViewCell.swift
//  test
//
//  Created by 王義甫 on 2020/6/29.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import UIKit

class settingsTableViewCell: UITableViewCell {
}

class changeUsernameCell: UITableViewCell{
    @IBOutlet var changeUsername: UILabel!
}

class changePasswordCell: UITableViewCell{
    @IBOutlet var changePassword: UILabel!
}

class editMyplaceCell: UITableViewCell{
    @IBOutlet var editMyplace: UILabel!
}

class myFriendCell: UITableViewCell{
    @IBOutlet var myFriend: UILabel!
}

class friendListCell: UITableViewCell{
    @IBOutlet var friendName: UILabel!
}
class pendingFriendListCell: UITableViewCell {
    @IBOutlet var pendingFriendName: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
}
