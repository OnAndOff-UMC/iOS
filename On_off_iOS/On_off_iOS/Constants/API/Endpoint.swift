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
    case preview = "/memoirs/previews?date=DATE"
}

enum FeedPath: String {
    case feedImage = "/feed-images"
    case workLifeBalacne = "/feeds?date=DATE"
    case checkWLB = "/feeds/FEEDID/check"
    case delayTomorrow = "/feeds/FEEDID/delay"
    case delete = "/feeds/FEEDID"
}

enum WeekDayPath: String {
    case weekdayInit = "/weekdays/init"
    case prevWeek = "/weekdays/prev?date=DATE"
    case nextWeek = "/weekdays/next?date=DATE"
}

enum MyPage: String {
    case myInfo = "/users/information"
}

enum StatisticsPath: String {
    case week = "/stats/week"
    case month = "/stats/month"
    case prevMonth = "/stats/month/prev?date=DATE"
    case nextMonth = "/stats/month/next?date=DATE"
}
