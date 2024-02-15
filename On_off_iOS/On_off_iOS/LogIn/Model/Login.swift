//
//  Login.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/01.
//

import Foundation

/// 카카오 토큰 검증 요청 구조체
struct KakaoTokenValidationRequest: Codable {
    let identityToken: String
    let accessToken: String
    let additionalInfo: AdditionalInfo
}

/// 애플 로그인 요청 구조체
struct AppleTokenValidationRequest: Codable {
   let oauthId: String
   let fullName: FullName
   let email: String
   let identityToken: String
   let authorizationCode: String
   let additionalInfo: AdditionalInfo
}

/// 추가 정보 구조체: 프로필: 분야, 직업, 경력
struct AdditionalInfo: Codable {
    let nickname: String
    let fieldOfWork: String
    let job: String
    let experienceYear: String
}

/// 사용자 이름 구조체
struct FullName: Codable {
    let giveName: String
    let familyName: String
}

/// ❎추후 Login파일말고 공동사용 구조체로서 이동할 파일 말할것
/// 응답구조체 Response
struct Response<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

struct TokenResult: Codable {
    let accessToken: String
    let refreshToken: String
}
