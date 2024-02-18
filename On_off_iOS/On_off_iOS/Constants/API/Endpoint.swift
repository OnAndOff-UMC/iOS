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
    
    /// 닉네임 중복성 검사
    case nicknameDuplicate = "/users/nickname"
    
    /// 직업
    case job = "/enums/field-of-works"
    case experienceYear = "/enums/experience-years"
    
    /// 마이페이지에서 수정할 정보
    case saveuserInfo = "/users/"
    

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

enum WorklogPath: String {
    case Worklog = "/on/worklog/worklogId" //체크,수정,삭제,내일로 미루기
    case addWorklog = "/on/worklog/" //조회 및 추가

}

enum OnPath: String {
    case On = "/on"
}

enum AlertPath: String {
    case alertStatus = "/users/pushNotification"
}

enum UserPath: String {
    case softDelete = "/users/withdraw"
}
