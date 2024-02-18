//
//  NickNameService.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/18.
//

import Foundation
import RxRelay
import RxSwift
import Alamofire

final class NickNameService: NickNameProtocol {
    private let disposeBag = DisposeBag()
    
    /// 닉네임 중복 검사
    func nicknameDuplicate(nickname: String) -> Observable<Response<String>> {
        let url = Domain.RESTAPI + LoginPath.nicknameDuplicate.rawValue
        let headers = Header.header.getHeader()

        return Observable.create { observer in
            
            AF.request(url,
                       method: .post,
                       parameters: ["nickname": nickname],
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<String>.self) { response in
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
