//
//  TodayResolution.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
//

import Foundation

//조회 Response
struct TodayResolution: Codable {
    let date: String?
    let resolutionDTOList: [ResolutionDTOList]?
}

struct ResolutionDTOList: Codable {
    let resolutionID: Int?
    let order: Int?
    let content: String?
}

//수정 request
struct ModifyResolutionRequest: Codable {
    let date: String?
    let resolutionDTOList : [ResolutionDTOList]?
}

//수정 Response
struct ModifyResolutionResponse: Codable {
    let date: String?
    let resolutionDTOList: [ResolutionDTOList]?
}

//추가 Request
struct AddResolutionRequest: Codable {
    let date: String?
    let content: String?
}

//추가 Response
struct AddResolutionResponse: Codable {
    let worklogId:  Int?
    let date: String?
    let content: String?
    let isChecked: Bool?
    let createdAt: String?
}

//삭제 Response
struct DeleteResolution: Codable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: Int?
}
