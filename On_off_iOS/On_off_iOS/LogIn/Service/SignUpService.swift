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
        let url = Domain.RESTAPI + LoginPath.signIn.rawValue
  
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
    
}
