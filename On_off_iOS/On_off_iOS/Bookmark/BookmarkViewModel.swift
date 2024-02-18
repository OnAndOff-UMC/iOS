//
//  BookmarkViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/03.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// BookmarkViewModel
final class BookmarkViewModel {
    
    private let disposeBag = DisposeBag()
    private let service = MemoirsService()
    
    /// Input
    struct Input {
        let reloadDataEvents: Observable<Void>
        let cellTapped: Observable<IndexPath>
        let bookmarkButtonTapped: Observable<IndexPath>
    }
    
    /// Output
    struct Output {
        var memoirList : BehaviorRelay<[Memoir]> = BehaviorRelay(value: [])
        /// 북마크 설정여부
        var bookMarkRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        /// 이미지
        var emoticonImageRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        /// 제목
        var dateRelay: BehaviorRelay<String?> = BehaviorRelay(value: nil)
        /// 위치(왼쪽 오른쪽)
        var locationRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    }
    
    /// binding Input
    /// - Parameters:
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input)-> Output {
        let output = Output()
        
        bindingViewDidLoad(input, output)
        
        return output
    }
    
//    /// BookmarkVC에서 재로드시 실행될 메소드
//    func reloadBookmarksData() {
//        let output = Output()
//        service.inquireBookmark(pageNumber: 0).subscribe(onNext: { [weak self] response in
//            guard let self = self, response.isSuccess ?? false else { return }
//            output.memoirList.accept(response.result.memoirList)
//        }).disposed(by: disposeBag)
//    }
    
    
    /// 처음 화면 떴을때 데이터 bindingViewDidLoad
    private func bindingViewDidLoad(_ input: Input, _ output: Output) {
        input.reloadDataEvents
            .flatMapLatest { [weak self] _ -> Observable<Response<BookMarkListResponse>> in
                guard let self = self else { return .empty() }
                
                return service.inquireBookmark(pageNumber: 0)
            }
            .subscribe(onNext: { response in
                guard let isSuccess = response.isSuccess, isSuccess else {
                    print("Error")
                    return
                }
                self.handleBookmarkResponse(response.result ?? BookMarkListResponse(memoirList: [], pageNumber: 0, pageSize: 0, totalPages: 0, totalElements: 0, isFirst: false, isLast: false), output: output)
            }, onError: { error in
                print("Error fetching bookmarks")
            })
            .disposed(by: disposeBag)
    }
    
    /// bindiㅜㅎ handleBookmarkResponse
    private func handleBookmarkResponse(_ response: BookMarkListResponse, output: Output) {
        response.memoirList.forEach { memoir in
            if let date = memoir.date, let emoticonUrl = memoir.emoticonUrl, let remain = memoir.remain {
                print("Memoir date: \(date), URL: \(emoticonUrl), Remain: \(remain)")
                
                output.memoirList.accept(response.memoirList)
                output.emoticonImageRelay.accept(emoticonUrl)
                output.dateRelay.accept(date)
                output.locationRelay.accept(remain % 2 == 0)
            }
        }
    }
    
}

