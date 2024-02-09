//
//  Login.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/01.
//

import Foundation

struct LoginRequest: Codable {
    let accessToken: String
    let refreshToken: String
}
/// 카카오 로그인
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

struct AdditionalInfo: Codable {
    let fieldOfWork: String
    let job: String
    let experienceYear: String
}

/// 로그인 결과 구조체
struct TokenValidationResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TokenResult
}

struct TokenResult: Codable {
    let accessToken: String
    let refreshToken: String
}


struct FullName: Codable {
    let giveName: String
    let familyName: String
}

/// 로그인 응답 구조체
struct LoginResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LoginResult
}

/// 로그인 결과 구조체
struct LoginResult: Codable {
    let infoSet: Bool
    let accessToken: String
    let refreshToken: String
}

struct ProfileOptionResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [String]
}

