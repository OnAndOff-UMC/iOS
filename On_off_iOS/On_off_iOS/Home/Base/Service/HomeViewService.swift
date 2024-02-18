//
//  HomeViewService.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/13/24.
//

import Foundation
import Alamofire
import RxSwift

final class HomeViewService {
    private let disposeBag = DisposeBag()
    
    /// 일주일 날짜 초기 가져오기
    /// - Returns: Week Day
    func weekDayInit() -> Observable<WeekDay?> {
        let url = Domain.RESTAPI + WeekDayPath.weekdayInit.rawValue
        let header = Header.header.getHeader()
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<WeekDay>.self) { response in
                print(#function, response)
                switch response.result {
                case .success(let data):
                    observer.onNext(data.result )
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// Get My Information
    /// - Returns: My Information
    func getMyNickName() -> Observable<String> {
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
                    observer.onNext(data.result?.nickname ?? "")
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// 이전 일주일 날짜 가져오기
    /// - Returns: Week Day
    /// - Parameter date: 선택한 날짜
    func movePrevWeek(date: String) -> Observable<WeekDay?> {
        let url = Domain.RESTAPI + WeekDayPath.prevWeek.rawValue
        let parameters: Parameters = ["date": date]
        let header = Header.header.getHeader()
        print(url, #function)
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<WeekDay>.self) { response in
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
    
    /// 다음 일주일 날짜 가져오기
    /// - Returns: Week Day
    /// - Parameter date: 선택한 날짜
    func moveNextWeek(date: String) -> Observable<WeekDay?> {
        let url = Domain.RESTAPI + WeekDayPath.nextWeek.rawValue
        let parameters: Parameters = ["date": date]
        let header = Header.header.getHeader()
        print(url, #function)
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<WeekDay>.self) { response in
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
    
}
