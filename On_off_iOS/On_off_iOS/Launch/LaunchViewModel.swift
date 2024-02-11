//
//  LaunchViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/09.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// LaunchViewModel
final class LaunchViewModel {
    
    private let loginService: LoginService
    private let disposeBag = DisposeBag()
    
    struct Input {
        /// 애니메이션 완료 신호를 처리할 Relay
        let animationCompleted: Observable<Void>
    }
    
    struct Output {
        /// 네비게이션 방향을 알리는 Observable
        let navigationSignal: Observable<LaunchNavigation>
        
    }
    
    // MARK: - Init
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func bind(input: Input) -> Output {
        let navigationSignal = input.animationCompleted
            .flatMapLatest { [weak self] _ -> Observable<LaunchNavigation> in
                guard let self = self,
                      let refreshToken = KeychainWrapper.loadItem(forKey: LoginKeyChain.refreshToken.rawValue),
                      let accessToken = KeychainWrapper.loadItem(forKey: LoginKeyChain.accessToken.rawValue) else {
                    return .just(.onBoarding) // 키체인에 정보가 없으면 온보딩으로
                }
                
                // 토큰 유효성 검사 요청
                let request = TokenValidationRequest(accessToken: accessToken, refreshToken: refreshToken)
                return self.loginService.validateTokenAndSendInfo(request: request)
                    .map { response in
                        response.isSuccess ? .main : .login // 응답 성공 시 메인, 실패 시 로그인으로
                    }
                    .catchAndReturn(.login) // 오류 발생 시 로그인 화면으로
            }
        
        return Output(navigationSignal: navigationSignal)
        
    }
}

