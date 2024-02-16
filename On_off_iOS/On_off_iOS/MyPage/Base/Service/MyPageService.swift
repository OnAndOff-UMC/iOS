//
//  MyPageService.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/15/24.
//

import Foundation
import Alamofire
import RxSwift

final class MyPageService {
    
    /// Get My Information
    /// - Returns: My Information
    func getMyInformation() -> Observable<MyInfo> {
        let url = Domain.RESTAPI + MyPage.myInfo.rawValue
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<MyInfo>.self) { response in
                print(#function, response)
                switch response.result {
                case .success(let data):
                    observer.onNext(data.result)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// 회원탈퇴 Soft Delete
    /// - Returns: true false
    func softDelete() -> Observable<Bool> {
        let url = Domain.RESTAPI + UserPath.softDelete.rawValue
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<User>.self) { response in
                print(#function, response)
                switch response.result {
                case .success(let data):
                    observer.onNext(data.isSuccess)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
