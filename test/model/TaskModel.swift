//
//  TaskModel.swift
//  test
//
//  Created by 王義甫 on 2020/4/8.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation

struct TaskModel{
    let taskId: Int32
    let taskName: String
    let taskTime: String
    let taskDeadline: String
    let taskLocation: Int32
    let reminder: String
    let addToCal: Bool
    let isPinned: Bool
    let isDone: Bool
}
