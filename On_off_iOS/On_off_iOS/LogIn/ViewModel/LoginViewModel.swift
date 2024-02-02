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
      //  let appleButtonTapped: Observable<ControlEvent<UITapGestureRecognizer>.Element>
    }
    
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
        return output
    }
    
    // MARK: - API Connect
    
    private func kakaoLogin() {
        // 카카오톡 앱으로 로그인 시도
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("Login Success.")
                    // 성공 시 토큰 정보를 서버에 전송
                    self?.sendTokenToServer(identityToken: oauthToken?.idToken ?? "", accessToken: oauthToken?.accessToken ?? "")
                }
            }
        } else {
            // 카카오 계정으로 로그인 시도
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("Login Success.")
                    // 성공 시 토큰 정보를 서버에 전송
                    self?.sendTokenToServer(identityToken: oauthToken?.idToken ?? "", accessToken: oauthToken?.accessToken ?? "")
                }
            }
        }
    }

    // 서버로 토큰 정보 전송
    private func sendTokenToServer(identityToken: String, accessToken: String) {
        let request = KakaoLoginRequest(identityToken: identityToken, accessToken: accessToken)
        // SignUpService 인스턴스 생성 및 signUpService 메서드 호출
        let signUpService = SignUpService()
        signUpService.signUpService(request: request)
            .subscribe(onNext: { response in
                print("Server Response: \(response)")
                // 서버 응답 처리
                // 예: self.output.checkSignInService.accept(response.message)
            }, onError: { error in
                print("Error sending tokens to server: \(error)")
            })
            .disposed(by: disposeBag)
    }
  
    /// 닉네임 설정으로 이동
    private func moveToNickName() {
        let vc = NickNameViewController(viewModel: NickNameViewModel(navigationController: navigationController))
        navigationController.pushViewController(vc, animated: true)
    }
}

