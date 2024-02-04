//
//  Domain.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/31.
//

import Foundation

/// Login 경로
enum LoginPath: String {
    
    /// 유효성 검사
    case checkValidation = "/token/validate"
    
    case signIn = "/oauth2/kakao/token/validate"
}

/// 회고록
enum MemoirsPath: String {
    case memoirsSave = "/Memoirs" //사용자ID넣기 수정
    case getEmoticon = "/emoticons"
}
