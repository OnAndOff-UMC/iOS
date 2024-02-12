//
//  InquireMemoirsViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/12.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// MemoirsViewModel
final class InquireMemoirsViewModel {
    
    private let disposeBag = DisposeBag()
    private let memoirsService = MemoirsService()
    
    // Input 구조체 정의
        struct Input {
            let bookMarkButtonTapped: Observable<Void>
            let menuButtonTapped: Observable<Void>
            let memoirId: Observable<String>
            let memoirInquiry: Observable<Void>
        }
        
        // Output 구조체 정의
        struct Output {
            let updateBookmarkStatus: Observable<Bool>
            let memoirInquiryResult: Observable<MemoirResponse>
        }
        
        // Input을 받아 Output을 반환하는 bind 함수
    func bind(input: Input) -> Output {
        let memoirInquiryResult = input.memoirInquiry
               .flatMapLatest { [weak self] _ -> Observable<MemoirResponse> in
                   guard let self = self else { return .empty() }
                   // "2024-02-12" 날짜를 사용하여 회고록 조회
                   return self.memoirsService.inquireMemoirs(date: "2024-02-12")
                       .catchAndReturn(MemoirResponse(isSuccess: false, code: "", message: "", result: MemoirResponse.MemoirResult(memoirId: 0, date: "", emoticonUrl: "", isBookmarked: false, memoirAnswerList: [])))
               }
        
        let updateBookmarkStatus = input.bookMarkButtonTapped
            .withLatestFrom(Observable.just("someMemoirId")) // 임시로 ID 사용, 필요에 따라 수정
            .flatMapLatest { [weak self] memoirId -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                return self.memoirsService.bookMarkMemoirs(memoirId: memoirId)
                    .map { response -> Bool in
                        return response.result.isBookmarked
                    }
                    .catchAndReturn(false)
            }
        
        return Output(updateBookmarkStatus: updateBookmarkStatus, memoirInquiryResult: memoirInquiryResult)
    }
}
