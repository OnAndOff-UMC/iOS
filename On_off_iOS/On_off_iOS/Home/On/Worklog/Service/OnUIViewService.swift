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
    func getWLList(date: String) -> Observable<[Worklog]> {
        let url = Domain.RESTAPI + WorklogPath.addWorklog.rawValue
            .replacingOccurrences(of: "DATE", with: "\(date)")
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<[Worklog]>.self) { response in
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
    
    /// Check Worklog
    /// - Parameter worklogId: worklog Id
    /// - Returns: 성공 여부
    func checkWL(worklogid: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + WorklogPath.Worklog.rawValue
            .replacingOccurrences(of: "worklogid", with: "\(worklogid)")
        let header = Header.header.getHeader()
        print(url)
        return Observable.create { observer in
            AF.request(url,
                       method: .patch,
                       headers: header)
            .validate(statusCode: 200..<201)
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
}
