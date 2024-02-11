//
//  Domain.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/31.
//

import Foundation

struct Domain {
    static let RESTAPI = "http://" + (Bundle.main.object(forInfoDictionaryKey: "IP") as? String ?? "") + ":" + (Bundle.main.object(forInfoDictionaryKey: "PORT") as? String ?? "")
}

enum FeedPath: String {
    case uploadImage = "/feed-images"
}
