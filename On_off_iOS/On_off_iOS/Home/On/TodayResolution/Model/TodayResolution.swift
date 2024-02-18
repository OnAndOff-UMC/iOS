//
//  TodayResolution.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
//

import Foundation

struct Resolution: Codable {
    let resolutionID: Int?
    let order: Int?
    let content: String?
}

//추가
struct AddResolution: Codable {
    let date: String?
    let content: String?
}
