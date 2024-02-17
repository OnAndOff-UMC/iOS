//
//  ClickWorklogService.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation
import Alamofire
import RxSwift

final class ClickWorklogService {
    
    /// 내일로 미루기
    /// - Parameter worklogid: worklog id
    /// - Returns: true false
    func delayTomorrow(worklogid: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + WorklogPath.Worklog.rawValue
            .replacingOccurrences(of: "worklogid", with: "\(worklogid)")
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .patch,
                       headers: header)
            .responseDecodable(of: Response<Worklog>.self) { response in
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
    
    
    /// 피드 삭제
    /// - Parameter WorklogId: Worklog Id
    /// - Returns: true false
    func deletelog(worklogid: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + WorklogPath.Worklog.rawValue
            .replacingOccurrences(of: "worklogid", with: "\(worklogid)")
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .delete,
                       headers: header)
            .responseDecodable(of: Response<Int>.self) { response in
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
