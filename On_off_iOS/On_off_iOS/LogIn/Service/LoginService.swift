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
    /// - Parameter request: Kakao에서 발급받는 Token
    /// - Returns:  Tokens
    func validateKakaoTokenAndSendInfo(request: KakaoTokenValidationRequest) -> Observable<Response<TokenResult>> {
        let url = Domain.RESTAPI + LoginPath.kakaoLogin.rawValue
        let headers = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url, method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate()
            .responseDecodable(of: Response<TokenResult>.self) { response in

                switch response.result {
                    
                case .success(let data):
                    print("로그인 성공: \(response)")
                    observer.onNext(data)
                    _ = KeychainWrapper.saveItem(value: data.result?.accessToken ?? "", forKey: LoginKeyChain.accessToken.rawValue)
                    _ = KeychainWrapper.saveItem(value: data.result?.refreshToken ?? "", forKey: LoginKeyChain.refreshToken.rawValue)

                    observer.onCompleted()
                    
                case .failure(let error):
                    print("로그인 실패:")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    /// - Parameter request: Apple에서 발급받는 Token
    /// - Returns:  Tokens
    func validateAppleTokenAndSendInfo(request: AppleTokenValidationRequest) -> Observable<Response<TokenResult>> {
        let url = Domain.RESTAPI + LoginPath.appleLogin.rawValue
        let headers = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url, method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate()
            .responseDecodable(of: Response<TokenResult>.self) { response in
                print(request)
                switch response.result {
                    
                case .success(let data):
                    print("👍로그인 성공: \(response)")
                    observer.onNext(data)
                    _ = KeychainWrapper.saveItem(value: data.result?.accessToken ?? "", forKey: LoginKeyChain.accessToken.rawValue)
                    _ = KeychainWrapper.saveItem(value: data.result?.refreshToken ?? "", forKey: LoginKeyChain.refreshToken.rawValue)
                    
                    observer.onCompleted()
                    
                case .failure(let error):
                    print("로그인 실패:")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    /// 직업 정보 가져오기
    func fetchJobOptions() -> Observable<Response<[String]>> {
        let url = Domain.RESTAPI + LoginPath.job.rawValue
        return Observable.create { observer in
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: Response<[String]>.self) { response in
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
    
    /// 연차 정보 가져오기
    func fetchExperienceYearsOptions() -> Observable<Response<[String]>> {
        let url = Domain.RESTAPI + LoginPath.experienceYear.rawValue
        return Observable.create { observer in
            AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: Response<[String]>.self) { response in
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
    
    /// 유효성 검사하기
    /// - Parameter request: 서버에서  발급받는 Token
    /// - Returns:  Tokens
    func validateTokenAndSendInfo(request: TokenResult) -> Observable<Response<TokenResult>> {
        let url = Domain.RESTAPI + LoginPath.checkValidation.rawValue
        let headers = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url, method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate()
            .responseDecodable(of: Response<TokenResult>.self) { response in
                
                switch response.result {
                    
                case .success(let data):
                    print("👍로그인 성공: \(response)")
                    observer.onNext(data)
                    _ = KeychainWrapper.saveItem(value: data.result?.accessToken ?? "", forKey: LoginKeyChain.accessToken.rawValue)
                    _ = KeychainWrapper.saveItem(value: data.result?.refreshToken ?? "", forKey: LoginKeyChain.refreshToken.rawValue)
                    observer.onCompleted()
                    
                case .failure(let error):
                    print("로그인 실패:")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}
