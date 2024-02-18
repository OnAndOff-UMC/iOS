//
//  MyInfoSettingService.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/17.
//

import Alamofire
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKUser
import RxRelay
import RxSwift

/// 로그인 Service
final class MyInfoSettingService: MyInfoSettingProtocol {
    private let disposeBag = DisposeBag()
    
    /// 직업 정보 가져오기
    func fetchJobOptions() -> Observable<Response<[String]>> {
        let url = Domain.RESTAPI + LoginPath.job.rawValue
        return Observable.create { observer in
            AF.request(url, method: .get)
                .validate(statusCode: 200..<201)
                .responseDecodable(of: Response<[String]>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    /// 연차 정보 가져오기
    func fetchExperienceYearsOptions() -> Observable<Response<[String]>> {
        let url = Domain.RESTAPI + LoginPath.experienceYear.rawValue
        return Observable.create { observer in
            AF.request(url, method: .get)
                .validate(statusCode: 200..<201)
                .responseDecodable(of: Response<[String]>.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    /// 내정보 수정완료하기
    func saveMyInformation(userInfo: UserInfoRequest) -> Observable<Response<UserInfoResult>> {
        let url = Domain.RESTAPI + LoginPath.saveuserInfo.rawValue
        print(userInfo)
        return Observable.create { observer in
            AF.request(url,
                       method: .put,
                       parameters: ["nickname": userInfo.nickname,
                                    "fieldOfWork": userInfo.fieldOfWork,
                                    "job": userInfo.job,
                                    "experienceYear": userInfo.experienceYear],
                       encoder: JSONParameterEncoder.default
            )
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<UserInfoResult>.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    /// 닉네임 중복 검사
    func nicknameDuplicate(nickname: String) -> Observable<Response<String>> {
        let url = Domain.RESTAPI + LoginPath.nicknameDuplicate.rawValue
        let headers = Header.header.getHeader()
        
        return Observable.create { observer in
            
            AF.request(url,
                       method: .post,
                       parameters: ["nickname": nickname],
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<String>.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getMyInformation() -> Observable<MyInfo> {
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
                    observer.onNext(data.result)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}


