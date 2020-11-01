//
//  FriendModel.swift
//  test
//
//  Created by 謝宛軒 on 2020/11/1.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation

struct FriendListModel {
    let friends: [FriendModel]
}

struct FriendModel {
    let friendId:Int32?
    let name: String
    let like: Int
    let heart: Int
    let mad: Int
    let isChecked: Bool
}
