//
//  Domain.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
//

import Foundation

struct Domain {
    static let RESTAPI = "http://" + (Bundle.main.object(forInfoDictionaryKey: "IP") as? String ?? "") + ":" + (Bundle.main.object(forInfoDictionaryKey: "PORT") as? String ?? "")
}
