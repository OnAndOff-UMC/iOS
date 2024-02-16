//
//  ClickWorkLifeBalanceFeedService.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/12/24.
//

import Foundation
import Alamofire
import RxSwift

final class ClickWorkLifeBalanceFeedService {
    
    /// 내일로 미루기
    /// - Parameter feedId: Feed Id
    /// - Returns: true false
    func delayTomorrow(feedId: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + FeedPath.delayTomorrow.rawValue
            .replacingOccurrences(of: "FEEDID", with: "\(feedId)")
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .patch,
                       headers: header)
            .responseDecodable(of: Response<Feed>.self) { response in
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
    /// - Parameter feedId: Feed Id
    /// - Returns: true false
    func deleteFeed(feedId: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + FeedPath.delete.rawValue
            .replacingOccurrences(of: "FEEDID", with: "\(feedId)")
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .delete,
                       headers: header)
            .responseDecodable(of: Response<Int>.self) { response in
                print(#function, response)
                switch response.result {
                case .success(let data):
                    observer.onNext(data.isSuccess  ?? false)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}
