//
//  Feed.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/12/24.
//

import Foundation

struct Feed: Codable {
    let feedId: Int?
    let isChecked: Bool?
    let date: String?
    let content: String?
}

struct AddFeed: Codable {
    let date: String?
    let content: String?
}
