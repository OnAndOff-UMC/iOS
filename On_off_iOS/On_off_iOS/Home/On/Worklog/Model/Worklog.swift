//
//  Worklog.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
//

import Foundation

struct Worklog: Codable {
    let worklogId: Int?
    let content: String?
    let isChecked: Bool?
}

struct AddWorklog: Codable {
    let date: String?
    let content: String?
}
