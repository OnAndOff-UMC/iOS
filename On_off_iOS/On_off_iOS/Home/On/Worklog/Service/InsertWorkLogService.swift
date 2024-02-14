//
//  InsertWorklogService.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
//

import Foundation
import Alamofire
import RxSwift
import Network

final class InsertWorkLogService {
    
    /// Add Worklog
    /// - Parameter Worklog: 추가할 log
    /// - Returns: Worklog
    func addWorklog(Worklog: AddWorklog) -> Observable<Bool> {
        let url = Domain.RESTAPI + WorklogPath.addWorklog.rawValue
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: Worklog,
                       encoder: JSONParameterEncoder.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Worklog>.self) { response in
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
    
    /// Insert Worklog
    /// - Parameter WorklogID: 수정할 Worklog ID
    /// - Returns: true false
    func insertlog(worklogid: Int, content: String) -> Observable<Bool> {
        let url = Domain.RESTAPI + WorklogPath.Worklog.rawValue
            .replacingOccurrences(of: "worklogid", with: "\(worklogid)")
        let body: Parameters = [ "content": content ]
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .patch,
                       parameters: body,
                       encoding: JSONEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Worklog>.self) { response in
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
