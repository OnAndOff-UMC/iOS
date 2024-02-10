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
            let navigationSubject = PublishSubject<LaunchNavigation>()
            
            input.animationCompleted
                .flatMapLatest { [unowned self] _ -> Observable<LaunchNavigation> in
                    guard let refreshToken = KeychainWrapper.loadItem(forKey: LoginKeyChain.refreshToken.rawValue),
                          let accessToken = KeychainWrapper.loadItem(forKey: LoginKeyChain.accessToken.rawValue) else {
                        return .just(.onBoarding)
                    }
                    
                    let request = TokenValidationRequest(accessToken: accessToken, refreshToken: refreshToken)
                    return self.loginService.validateTokenAndSendInfo(request: request)
                        .map { response in
                            response.isSuccess ? .main : .login
                        }
                        .catchAndReturn(.onBoarding)
                }
                .bind(to: navigationSubject)
                .disposed(by: disposeBag)
            
            return Output(navigationSignal: navigationSubject.asObservable())
        }
    }

