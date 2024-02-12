//
//  InsertWorkLifeBalanceFeedService.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/12/24.
//

import Foundation
import Alamofire
import RxSwift

final class InsertWorkLifeBalanceFeedService {
    
    /// Add Feed
    /// - Parameter feed: 추가할 Feed
    /// - Returns: Feed
    func addFeed(feed: AddFeed) -> Observable<Bool> {
        let url = Domain.RESTAPI + FeedPath.workLifeBalacne.rawValue
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: feed,
                       encoder: JSONParameterEncoder.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Feed>.self) { response in
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
    
    /// Insert Feed
    /// - Parameter feedId: 수정할 Feed Id
    /// - Returns: true false
    func insertFeed(feedId: Int, content: String) -> Observable<Bool> {
        let url = Domain.RESTAPI + FeedPath.delete.rawValue
            .replacingOccurrences(of: "FEEDID", with: "\(feedId)")
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
            .responseDecodable(of: Response<Feed>.self) { response in
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
