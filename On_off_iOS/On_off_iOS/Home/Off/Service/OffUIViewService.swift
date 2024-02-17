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
        let url = Domain.RESTAPI + FeedPath.feedImage.rawValue
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<[Image]>.self) { response in
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
    
    /// 선택한 이미지 업로드
    /// - Parameter image: 선택한 이미지
    /// - Returns: 성공 여부
    func uploadImage(image: UIImage) -> Observable<Bool> {
        let url = Domain.RESTAPI + FeedPath.feedImage.rawValue
        var header = Header.header.getHeader()
        header.add(HTTPHeader(name: "Content-Type", value: "multipart/form-data"))
        print(#function, header)
        print(url)
        
        return Observable.create { observer in
            AF.upload(multipartFormData: { multipartFormData in
                if let image = image.jpegData(compressionQuality: 0) {
                    multipartFormData.append(image, withName: "image", fileName: "\(image).png", mimeType: "multipart/form-data")
                }
            }, to: url, method: .post, headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Image>.self) { response in
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
    
    /// 이미지 삭제
    /// - Parameter imageId: 이미지 Id
    /// - Returns: 결과 true, false
    func deleteImage(imageId: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + FeedPath.feedImage.rawValue + "/\(imageId)"
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .delete,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<Int>.self) { response in
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
    
    /// 워라벨 피드 목록 불러오기
    /// - Parameter date: 선택한 날짜
    /// - Returns: Feed List
    func getWLBFeedList(date: String) -> Observable<[Feed]> {
        let url = Domain.RESTAPI + FeedPath.workLifeBalacne.rawValue
        let parameters: Parameters = ["date": date]
        let header = Header.header.getHeader()
        print(#function, url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<[Feed]>.self) { response in
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
    
    /// Check WLB Feed
    /// - Parameter feedId: Feed Id
    /// - Returns: 성공 여부
    func checkWLBFeed(feedId: Int) -> Observable<Bool> {
        let url = Domain.RESTAPI + FeedPath.checkWLB.rawValue
            .replacingOccurrences(of: "FEEDID", with: "\(feedId)")
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .patch,
                       headers: header)
            .validate(statusCode: 200..<201)
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
    
    /// Check Memoirs Preview
    /// - Parameter feedId: Feed Id
    /// - Returns: 성공 여부
    func checkMemoirsPreview(date: String) -> Observable<MemoirPreview> {
        let url = Domain.RESTAPI + MemoirsPath.preview.rawValue
        let parameters: Parameters = ["date": date]
        let header = Header.header.getHeader()
        print(url)
        
        return Observable.create { observer in
            AF.request(url,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<201)
            .responseDecodable(of: Response<MemoirPreview>.self) { response in
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
