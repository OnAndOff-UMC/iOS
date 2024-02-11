//
//  OffUIViewService.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/11/24.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

final class OffUIViewService {
    private let disposeBag = DisposeBag()
    
    /// 저장한 이미지 가져오기
    /// - Returns: 이미지 URL 배열
    func getImageList() -> Observable<[Image]> {
        let url = "/feed-images"
        let header: HTTPHeaders = [
            "authorization": "Bearer "
        ]
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: [Image].self) { response in
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
    
    /// 선택한 이미지 업로드
    /// - Parameter image: 선택한 이미지
    /// - Returns: 성공 여부
    func uploadImage(image: UIImage) -> Observable<Bool> {
        let url = "/feed-images"
        let header: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "authorization": "Bearer "
        ]
        
        return Observable.create { observer in
            AF.upload(multipartFormData: { MultipartFormData in
                if let image = image.pngData() {
                    MultipartFormData.append(image, withName: "img", fileName: "\(image).jpg", mimeType: "image/jpg")
                }
            }, to: url, method: .post, headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Bool.self) { response in
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
    
    /// 이미지 삭제
    /// - Parameter imageId: 이미지 Id
    /// - Returns: 결과 true, false
    func deleteImage(imageId: Int) -> Observable<Bool> {
        let url = "/feed-images/\(imageId)"
        let header: HTTPHeaders = [
            "authorization": "Bearer "
        ]
        
        return Observable.create { observer in
            AF.request(url,
                       method: .delete,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Bool.self) { response in
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
