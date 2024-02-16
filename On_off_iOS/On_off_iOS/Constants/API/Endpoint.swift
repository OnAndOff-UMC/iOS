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
    case nicknameDuplicate = "/users/nickname"
    
    /// 직업
    case job = "/enums/field-of-works"
    case experienceYear = "/enums/experience-years"
}

/// 회고록
enum MemoirsPath: String {
    case memoirsSave = "/memoirs" //회고록 저장,보기
    case memoirsRevise = "/memoirs/MEMOIRID" // 회고록 수정
    case bookMark = "/memoirs/MEMOIRID/bookmark" // 북마크 체크
    case bookMarkPreview = "/memoirs/bookmarks" // 북마크 회고
    case getEmoticon = "/emoticons"
    case preview = "/memoirs/previews"
}

enum FeedPath: String {
    case feedImage = "/feed-images"
    case workLifeBalacne = "/feeds"
    case checkWLB = "/feeds/FEEDID/check"
    case delayTomorrow = "/feeds/FEEDID/delay"
    case delete = "/feeds/FEEDID"
}

enum WeekDayPath: String {
    case weekdayInit = "/weekdays/init"
    case prevWeek = "/weekdays/prev"
    case nextWeek = "/weekdays/next"
}

enum MyPage: String {
    case myInfo = "/users/information"
}

enum StatisticsPath: String {
    case week = "/stats/week"
    case month = "/stats/month"
    case prevMonth = "/stats/month/prev"
    case nextMonth = "/stats/month/next"
}

enum AlertPath: String {
    case alertStatus = "/users/pushNotification"
}

enum UserPath: String {
    case softDelete = "/users/withdraw"
}
