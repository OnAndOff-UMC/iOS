//
//  Endpoint.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/31.
//

import Foundation

/// Login 경로
enum LoginPath: String {
    
    /// 유효성 검사
    case checkValidation = "/token/validate"
    case kakaoLogin = "/oauth2/kakao/token/validate"
    case appleLogin = "/oauth2/apple/token/validate"
    
    /// 직업
    case job = "/enums/field-of-works"
    case experienceYear = "/enums/experience-years"
}

/// 회고록
enum MemoirsPath: String {
    case memoirsSave = "/Memoirs"
    case getEmoticon = "/emoticons"
}

enum WorklogPath: String {
    case Worklog = "/on/worklog/worklogId" //체크,수정,삭제,내일로 미루기
    case addWorklog = "/on/worklog" //조회 및 추가
}

enum OnPath: String {
    case On = "/on"
}
