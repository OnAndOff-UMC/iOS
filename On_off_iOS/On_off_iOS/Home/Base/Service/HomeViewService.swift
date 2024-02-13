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
    func weekDayInit() -> Observable<WeekDay> {
        let url = Domain.RESTAPI + WeekDayPath.weekdayInit.rawValue
        let header = Header.header.getHeader()
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
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
