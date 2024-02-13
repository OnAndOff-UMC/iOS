//
//  EndPoint.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
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

enum FeedPath: String {
    case feedImage = "/feed-images"
    case workLifeBalacne = "/feeds?date=DATE"
    case checkWLB = "/feeds/FEEDID/check"
    case delayTomorrow = "/feeds/FEEDID/delay"
    case delete = "/feeds/FEEDID"
}

///ON-업무일지
enum WorklogPath: String {
    case worklog = "/on/worklog/worklogid"
//    case checkWLP = "/on/worklog/worklogid"
//    case delaylogTommorow = "/on/worklog/worklogId"
//    case deletelog = "/on/worklog/worklogId"
}
