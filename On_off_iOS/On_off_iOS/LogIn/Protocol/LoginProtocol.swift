//
//  LoginProtocol.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

protocol LoginProtocol {
    /// 카카오 로그인
    func kakaoLogin() -> Observable<KakaoSDKUser.User>
    
    /// 로그인 API
    /// - Parameter request: Kakao, Apple에서 발급받는 Token, AuthType
    /// - Returns: status, Tokens
    func validateKakaoTokenAndSendInfo(request: KakaoTokenValidationRequest) -> Observable<Response<TokenResult>>
    func validateAppleTokenAndSendInfo(request: AppleTokenValidationRequest) -> Observable<Response<TokenResult>>
}
