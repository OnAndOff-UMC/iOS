//
//  StatisticsService.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/14/24.
//

import Foundation
import Alamofire
import RxSwift

final class StatisticsService {
    
    /// 이번 주 성공 비율
    /// - Returns: WeekStatistics
    func getWeekAchieveRate() -> Observable<WeekStatistics> {
        let url = Domain.RESTAPI + StatisticsPath.week.rawValue
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<WeekStatistics>.self) { response in
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
    
    /// 이번 달 성공 비율
    /// - Returns: WeekStatistics
    func getMonthAchieveRate() -> Observable<MonthArchive> {
        let url = Domain.RESTAPI + StatisticsPath.month.rawValue
        let header = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<MonthArchive>.self) { response in
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
    
    /// 이전 달 성공 비율
    /// - Returns: WeekStatistics
    func getPrevMonthAchieveRate(date: String) -> Observable<MonthArchive> {
        let url = Domain.RESTAPI + StatisticsPath.prevMonth.rawValue
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
            .responseDecodable(of: Response<MonthArchive>.self) { response in
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
    
    /// 다음 달 성공 비율
    /// - Returns: WeekStatistics
    func getNextMonthAchieveRate(date: String) -> Observable<MonthArchive> {
        let url = Domain.RESTAPI + StatisticsPath.nextMonth.rawValue
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
            .responseDecodable(of: Response<MonthArchive>.self) { response in
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
