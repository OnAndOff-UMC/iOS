//
//  Worklog.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation

/// 업무일지 조회
struct WorkGetlogDTO: Codable {
    let worklogId: Int?
    let date: String?
    let content: String?
    let isChecked: Bool?
}

/// 업무일지 추가 request
struct AddWorklogRequest: Codable {
    let date: String?
    let content: String?
}

/// 업무일지 추가 response
struct AddWorklogResponse: Codable {
    let worklogId: Int?
    let date: String?
    let content: String?
    let isChecked: Bool?
    let createdAt: String?
}

/// 업무일지 수정하기 request
struct ModifyWorklogRequest: Codable {
    let content: String?
}

/// 업무일지 수정하기 response
struct ModifyWorklogResponse: Codable {
    let worklogId: Int?
    let date: String?
    let content: String?
    let isChecked: Bool?
    let updatedAt: String?
}

/// 업무일지 체크하기
struct CheckWorklog: Codable {
    let worklogId: Int?
    let date: String?
    let content: String?
    let isChecked: Bool?
    let updatedAt: String?
}

/// 업무일지 삭제하기
struct DeleteWorklog: Codable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: Int?
}

/// 업무일지 미루기
struct delaylog: Codable {
    let worklogId: Int?
    let date: String?
    let content: String?
    let isChecked: Bool?
    let createdAt: String?
    let updatedAt: String?
}
