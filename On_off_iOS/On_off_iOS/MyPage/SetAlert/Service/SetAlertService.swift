//
//  SetAlertService.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/16/24.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

final class SetAlertService {
    
    /// Get Alert Status
    func getAlertStatus() -> Observable<Alert> {
        let url = Domain.RESTAPI + AlertPath.alertStatus.rawValue
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Alert>.self) { response in
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
    
    /// Send Alert Info
    /// - Parameter info: Alert
    func sendAlertInfo(info: Alert) -> Observable<Bool> {
        let url = Domain.RESTAPI + AlertPath.alertStatus.rawValue
        let header = Header.header.getHeader()
        print(#function, info)
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: info,
                       encoder: JSONParameterEncoder.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Alert>.self) { response in
                print(#function, response)
                switch response.result {
                case .success(let data):
                    observer.onNext(data.isSuccess ?? false)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
