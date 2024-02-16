//
//  AlertWeekDay.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/16/24.
//

import Foundation

struct Alert: Codable {
    let pushNotificationTime: String?
    let receivePushNotification: Bool?
    var monday: Bool?
    var tuesday: Bool?
    var wednesday: Bool?
    var thursday: Bool?
    var friday: Bool?
    var saturday: Bool?
    var sunday: Bool?
}
