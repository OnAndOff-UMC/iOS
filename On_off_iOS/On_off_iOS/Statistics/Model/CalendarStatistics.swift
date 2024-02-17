//
//  CalendarStatistics.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/18/24.
//

import Foundation

struct CalendarStatistics: Codable {
    let date: String?
    let rate: Double?
}

struct MonthArchive: Codable {
    let date: String?
    let avg: Int?
    let monthStatsList: [CalendarStatistics]?
}
