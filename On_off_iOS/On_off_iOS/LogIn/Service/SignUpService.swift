//
//  SignUpService.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/01.
//

import Alamofire
import Foundation
import RxSwift

final class SignUpService: SignUpProtocol {
    private let disposeBag = DisposeBag()
    
    /// 회원가입할 떄 호출
    /// - Parameter request: 서버에 보내는 회원가입 정보
    /// - Returns: 회원 상태, AccesToken, RefreshToken
    func signUpService(request: KakaoLoginRequest) -> Observable<LoginResponse> {
        let header = Header.header.getHeader()
        let url = Domain.RESTAPI + LoginPath.kakaoLogin.rawValue
  
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: LoginResponse.self) { response in
               //print(response)
                switch response.result {
                case .success(let data):
                    print("😛\(data)")
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    /// Access Token 유효성 검사
    /// - Returns: true: AccessToken 유효, false: 만료
    func checkAccessTokenValidation() -> Observable<Void> {
        let url = Domain.RESTAPI + LoginPath.checkValidation.rawValue
        let header = Header.header.getHeader()
        
        print(#function)
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 204..<205)
            .response { res in
                switch res.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    print(#function)
                    print(error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
