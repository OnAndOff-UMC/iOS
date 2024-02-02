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
    // 서버 응답 처리
    private func kakaoLogin() {
         if UserApi.isKakaoTalkLoginAvailable() {
             UserApi.shared.loginWithKakaoTalk(completion: { [weak self] (oauthToken, error) in
                 self?.handleLoginResult(oauthToken: oauthToken, error: error)
             })
         } else {
             UserApi.shared.loginWithKakaoAccount(completion: { [weak self] (oauthToken, error) in
                 self?.handleLoginResult(oauthToken: oauthToken, error: error)
             })
         }
     }
    
    /// 카카오톡로그인과 카카오 로그인 공통로직 서버 연결
    private func handleLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print("Login Error: \(error)")
            return
        }
        
        guard let oauthToken = oauthToken else { return }
        sendTokenToServer(identityToken: oauthToken.idToken ?? "", accessToken: oauthToken.accessToken)
    }
    
    // 서버로 토큰 정보 전송
    private func sendTokenToServer(identityToken: String, accessToken: String) {
           let request = KakaoLoginRequest(identityToken: identityToken, accessToken: accessToken)
        let signUpService = SignUpService()
           signUpService.signUpService(request: request)
               .subscribe(onNext: { [weak self] response in
                   if response.isSuccess {
                       // 사용자 정보가 있는경우 - 메인, 없으면 정보 입력페이지로 이동
                       if response.result.infoSet {
                           self?.moveToMain()
                       } else {
                           self?.moveToNickName()
                       }
                   } else {
                       print("Login Failed: \(response.message)")
                   }
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
    /// 메인 화면으로 이동
    private func moveToMain() {
        print("메인 이동")
        let vc = NickNameViewController(viewModel: NickNameViewModel(navigationController: navigationController))
        navigationController.pushViewController(vc, animated: true)
    }
}

