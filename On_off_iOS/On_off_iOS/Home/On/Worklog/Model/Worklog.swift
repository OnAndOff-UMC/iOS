//
//  Worklog.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation

struct Worklog: Codable {
    let worklogId: Int?
    let content: String?
    let isChecked: Bool?
    let date: String?
    let createdAt: String?

}

struct AddWorklog: Codable {
    let date: String?
    let content: String?
}

struct On: Codable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
}

struct Result: Codable {
    let userId: Int?
    let date: String?
    let week: Week?
    let resolutionDTOList: [ResolutionDTO]
    let worklogDTOList: [WorklogDTO]
}

struct Week: Codable {
    let today: String?
    let on: Int?
    let off: Int?
    let weekOfMonth: Int?
    let weekStatsDTO: WeekStatsDTO
}

struct WeekStatsDTO: Codable {
    let mon: Int?
    let tue: Int?
    let wed: Int?
    let thu: Int?
    let fri: Int?
    let sat: Int?
    let sun: Int?
}

struct ResolutionDTO: Codable {
    let resolutionId: Int?
    let order: Int?
    let content: String?
}

struct WorklogDTO: Codable {
    let worklogId: Int?
    let content: String?
    let isChecked: Bool?
}
