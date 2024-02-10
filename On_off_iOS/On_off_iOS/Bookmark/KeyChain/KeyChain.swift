//
//  KeyChain.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/04.
//

import Foundation

// MARK: - ❎키체인어캐 나눌지 말해보기
/// MemoirsKeyChain : 키체인
enum MemoirsKeyChain: String {
    case MemoirsAnswer1
    case MemoirsAnswer2
    case MemoirsAnswer3
}

/// LoginKeyChain : 키체인
enum LoginKeyChain: String {
    case accessToken
    case refreshToken
}

/// 토큰 유효성 확인 토큰 키체인 값
struct TokenValidationRequest: Codable {
    let accessToken: String
    let refreshToken: String
}

/// login 종류 식별
enum LoginMethod: String{
    case loginMethod
}

/// 카카오 로그인 키체인값
enum KakaoLoginKeyChain: String {
    case accessToken
    case idToken
}

/// 애플 로그인 키체인값
enum AppleLoginKeyChain: String {
    case oauthId
    case giveName
    case familyName
    case email
    case identityTokenString
    case authorizationCodeString
}

/// 프로필 키체인 값
enum ProfileKeyChain: String {
    case fieldOfWork
    case job
    case experienceYear
}
