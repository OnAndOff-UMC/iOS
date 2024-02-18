//
//  OnUIViewService.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation
import Alamofire
import RxSwift
import UIKit
import Network

final class OnUIViewService {
    private let disposeBag = DisposeBag()
    
    /// Worklog 목록 불러오기
    /// - Parameter date: 선택한 날짜
    /// - Returns: Feed List
    func getWLList(date: String) -> Observable<[WorkGetlogDTO]> {
        let url = Domain.RESTAPI + WorklogPath.addWorklog.rawValue
        let parameters: Parameters = ["date": date]
        let header = Header.header.getHeader()
        print(#function, url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<[WorkGetlogDTO]>.self) { response in
                print(#function, response)
                switch response.result {
                case .success(let data):
                    observer.onNext(data.result ?? [])
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    /// Check Worklog
    /// - Parameter worklogId: worklog Id
    /// - Returns: 성공 여부
    func checkWL(worklogId: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + WorklogPath.Worklog.rawValue
            .replacingOccurrences(of: "worklogId", with: "\(worklogId)")
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .put,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<CheckWorklog>.self) { response in
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
