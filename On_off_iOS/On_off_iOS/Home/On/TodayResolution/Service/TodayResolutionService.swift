//
//  TodayResolutionService.swift
//  On_off_iOS
//
//  Created by 신예진 on 3/26/24.
//

import Alamofire
import RxSwift
import UIKit

///TodayResolutionService
final class TodayResolutionService {
    
    private let disposeBag = DisposeBag()
    
    ///오늘의 다짐 저장 == 추가하기
    func saveResolution(request: AddResolutionRequest) -> RxSwift.Observable<AddResolutionResponse> {
        let url = Domain.RESTAPI + ResolutionPath.Resolution.rawValue
        let headers = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: AddResolutionResponse.self) { response in
                print(request)
                
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
                print(response)
            }
            return Disposables.create()
        }
    }
    
    /// 오늘의 다짐 수정하기
    func reviseResolution(request: ModifyResolutionResponse, resolutionID: Int) -> RxSwift.Observable<ModifyResolutionResponse> {
        let url = Domain.RESTAPI + ResolutionPath.Resolution.rawValue
            .replacingOccurrences(of: "resolutionID", with: String(resolutionID))
        let headers = Header.header.getHeader()
        
        return Observable.create { observer in
            AF.request(url,
                       method: .put,
                       parameters: request,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: ModifyResolutionResponse.self) { response in
                print(request)
                
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
                print(response)
            }
            return Disposables.create()
        }
    }
    
    /// 오늘의 다짐 삭제하기
    func deleteResolution(date: String, resolutionID: Int) -> RxSwift.Observable<Response<Int>> {
        let url = Domain.RESTAPI + ResolutionPath.deleteResolution.rawValue
            .replacingOccurrences(of: "resolutionID", with: String(resolutionID))
        let headers = Header.header.getHeader()
        print(url)
        return Observable.create { observer in
            AF.request(url,
                       method: .delete,
                       headers: headers)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Int>.self) { response in
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            observer.onError(error)
                        }
                print(response)
            }
            return Disposables.create()
        }
    }
    
    /// 오늘의 다짐  조회하기
    func inquireResolution(date: String) -> Observable<TodayResolution> {
        let url = Domain.RESTAPI + ResolutionPath.Resolution.rawValue
        let headers = Header.header.getHeader()
        let parameters: Parameters = ["date": date]
        print(#function, url, date)
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: headers)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: TodayResolution.self) { response in
                print(#function, response)
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
                
            }
            return Disposables.create()
        }
    }
    
    
    
}
