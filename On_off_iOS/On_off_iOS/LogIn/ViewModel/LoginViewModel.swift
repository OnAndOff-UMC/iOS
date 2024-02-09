//
//  LoginViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

/// LoginViewModel
final class LoginViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    private var loginService: LoginService?
    
    /// Input
    struct Input {
        let kakaoButtonTapped: Observable<ControlEvent<UITapGestureRecognizer>.Element>
        let appleLoginSuccess: Observable<Void>
    }
    
    /// Output
    struct Output {
        var checkSignInService: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController, loginService: LoginService) {
        self.navigationController = navigationController
        self.loginService = loginService
    }
    
    /// binding Input
    /// - Parameters:
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = createOutput(input: input)
        
        return output
    }
    
    /// create Output
    /// - Parameters:
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    private func createOutput(input: Input) -> Output {
        let output = Output()
        input.kakaoButtonTapped
            .bind { [weak self] _ in
                guard let self = self else {return}
                print("called kakaoLogin")
                kakaoLogin()
            }
            .disposed(by: disposeBag)
        
        input.appleLoginSuccess
            .subscribe(onNext: { [weak self] _ in
                self?.moveToNickName()
            })
            .disposed(by: disposeBag)
        
        
        return output
    }
    
    // 서버 응답 처리
    // MARK: - 카카오 로그인 로직
    /// 카카오 로그인 처리
    /// - Parameters:
    ///   - oauthToken: OAuth 토큰
    ///   - error: 발생한 에러
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print("Login Error: \(error.localizedDescription)")
            return
        }

        guard let oauthToken = oauthToken else { return }
        
        // Keychain에 토큰 정보 저장
        if let refreshToken = oauthToken.idToken {
            _ = KeychainWrapper.saveItem(value: "kakao", forKey: LoginMethod.loginMethod.rawValue)
            
            let saveAccessTokenSuccess = KeychainWrapper.saveItem(value: oauthToken.accessToken, forKey: KakaoLoginKeyChain.accessToken.rawValue)
            let saveIdTokenSuccess = KeychainWrapper.saveItem(value: oauthToken.idToken ?? "", forKey: KakaoLoginKeyChain.idToken.rawValue)
            
            // 저장 성공 여부 확인
            if saveAccessTokenSuccess && saveIdTokenSuccess {
                print("Access Token과 ID Token 저장 성공")
                moveToNickName()
            } else {
                print("토큰 저장 실패")
            }
        }
    }
    
    /// 카카오 로그인 수행
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(completion: { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            })
        } else {
            UserApi.shared.loginWithKakaoAccount(completion: { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            })
        }
    }
    
    /// 닉네임 설정으로 이동
    private func moveToNickName() {
        let vc = NickNameViewController(viewModel: NickNameViewModel(navigationController: navigationController))
        navigationController.pushViewController(vc, animated: true)
    }
    
    /// 메인 화면으로 이동
    private func moveToMain() {
        print("메인 이동")
        let vc = NickNameViewController(viewModel: NickNameViewModel(navigationController: navigationController))
        navigationController.pushViewController(vc, animated: true)
    }
}

