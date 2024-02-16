//
//  User.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/17/24.
//

import Foundation

struct User: Codable {
    let id: Int?
    let infoSet: Bool?
    let name: String?
    let nickname: String?
    let email: String?
    let fieldOfWork: String?
    let job: String?
    let experienceYear: String?
    let status: String?
    let inactiveDate: String?
    let receivePushNotification: Bool?
    let socialType: String?
    let createdAt: String?
    let updatedAt: String?
}
