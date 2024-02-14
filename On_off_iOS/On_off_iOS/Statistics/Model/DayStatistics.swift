//
//  DayStatistics.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/11/24.
//

import Foundation

struct DayStatistics: Codable {
    let monday: Float?
    let tuesday: Float?
    let wendseday: Float?
    let thursday: Float?
    let friday: Float?
    let saturday: Float?
    let sunday: Float?
    
    enum CodingKeys: String, CodingKey {
        case monday = "mon"
        case tuesday = "tue"
        case wendseday = "wen"
        case thursday = "thu"
        case friday = "fri"
        case saturday = "sat"
        case sunday = "sun"
    }
}

struct WeekStatistics: Codable {
    let today: String?
    let on: Double?
    let off: Double?
    let weekOfMonth: Int?
    let weekStatsDTO: DayStatistics?
}
