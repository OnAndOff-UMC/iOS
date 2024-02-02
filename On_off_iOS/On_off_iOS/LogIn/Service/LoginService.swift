//
//  LoginService.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import Alamofire
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKUser
import RxRelay
import RxSwift

/// 로그인 Service
final class LoginService: LoginProtocol {
    private let disposeBag = DisposeBag()
    
    /// 카카오 로그인
    func kakaoLogin() -> Observable<KakaoSDKUser.User> {
        return Observable.create { [weak self] observer in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .flatMap { _ in self?.fetchKakaoUserInfo() ?? .empty() }
                    .subscribe(
                        onNext: { userInfo in
                            observer.onNext(userInfo)
                            observer.onCompleted()
                        },
                        onError: { error in
                            observer.onError(error)
                        }
                    )
                    .disposed(by: self?.disposeBag ?? DisposeBag())
                return Disposables.create()
            }
            
            UserApi.shared.rx.loginWithKakaoAccount()
                .flatMap { _ in self?.fetchKakaoUserInfo() ?? .empty() }
                .subscribe(
                    onNext: { userInfo in
                        observer.onNext(userInfo)
                    },
                    onError: { error in
                        print("loginWithKakaoAccount() error: \(error)")
                    }
                )
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    /// 카카오 사용자 정보 불러오기
    func fetchKakaoUserInfo() -> Observable<KakaoSDKUser.User> {
        return UserApi.shared.rx.me().asObservable()
            .do(onNext: { user in
                print("fetchKakaoUserInfo \n\(user)")
            }, onError: { error in
                print("fetchKakaoUserInfo error!\n\(error)")
            })
    }
    
    /// 로그인 API
    /// - Parameter request: Kakao, Apple에서 발급받는 Token, AuthType
    /// - Returns: status, Tokens
    // SignInService.swift

    func signInService(request: KakaoLoginRequest) -> Observable<LoginResponse> {
        let url = Domain.RESTAPI + LoginPath.signIn.rawValue
        return Observable.create { observer in
            AF.request(url, method: .post, parameters: ["identityToken": request.identityToken, "accessToken": request.accessToken], encoder: JSONParameterEncoder.default)
                .validate()
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
