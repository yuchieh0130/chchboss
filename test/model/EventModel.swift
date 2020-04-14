//
//  eventModel.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/10.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation

struct EventModel{
    let eventId: Int32?
    let eventName: String
    let startDate: String
    let startTime: String?
    let endDate: String
    let endTime: String?
    let allDay: Bool
    let autoRecord: Bool
    let task: Bool
    let reminder: Bool
    let taskId: Int32?
}

