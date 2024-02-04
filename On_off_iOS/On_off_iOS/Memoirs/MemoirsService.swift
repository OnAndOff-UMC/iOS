//
//  MemoirsService.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import Alamofire
import RxSwift
import UIKit

final class MemoirsService: MemoirsProtocol {
    
    private let disposeBag = DisposeBag()
    
  /// 회고록 저장하기
    func saveMemoirs(request: MemoirRequest) -> RxSwift.Observable<MemoirResponse> {
        let url = Domain.RESTAPI + MemoirsPath.memoirsSave.rawValue
        print(request)
        return Observable.create { observer in
            AF.request(url,
                       method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: MemoirResponse.self) { response in

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
    
    /// 이모티콘 띄우기
    func getEmoticon() -> RxSwift.Observable<EmoticonResponse> {
        let url = Domain.RESTAPI + MemoirsPath.getEmoticon.rawValue
        return Observable.create { observer in
            AF.request(url,
                       method: .get)
                .validate(statusCode: 200..<201) // 상태 코드 범위를 200~299로 확장
                .responseDecodable(of: EmoticonResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        print("😛\(data)")
                        observer.onNext(data)
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}

