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
        let reviseButtonTapped: Observable<Void>
        let memoirInquiry: Observable<Void>
        let toggleEditing: Observable<Void>
        let learnedText: Observable<String?>
        let praisedText: Observable<String?>
        let improvementText: Observable<String?>
    }
    
    // Output 구조체 정의
    struct Output {
        let updateBookmarkStatus: Observable<Bool>
        let memoirInquiryResult: Observable<MemoirResponse>
        let isEditing: Observable<Bool>
        let reviseResult: Observable<Bool>
    }
    
    func bind(input: Input) -> Output {
        let isEditingRelay = BehaviorRelay<Bool>(value: false)

        let memoirInquiryResult = inquireMemoirsObservable(input.memoirInquiry)
        
        let updateBookmarkStatus = updateBookmarkStatusObservable(input.bookMarkButtonTapped, memoirInquiryResult)
        
        let reviseResult = reviseMemoirsObservable(input.reviseButtonTapped, input.learnedText, input.praisedText, input.improvementText)
        
        return Output(updateBookmarkStatus: updateBookmarkStatus,
                      memoirInquiryResult: memoirInquiryResult,
                      isEditing: isEditingRelay.asObservable(),
                      reviseResult: reviseResult)
    }

    private func inquireMemoirsObservable(_ trigger: Observable<Void>) -> Observable<MemoirResponse> {
        return trigger
            .flatMapLatest { [weak self] _ -> Observable<MemoirResponse> in
                guard let self = self else { return .empty() }
                // 날짜를 사용하여 회고록 조회 (예시로 "2024-02-14"를 사용)
                return self.memoirsService.inquireMemoirs(date: "2024-02-14")
                    .catchAndReturn(MemoirResponse(isSuccess: false, code: "", message: "", result: MemoirResponse.MemoirResult(memoirId: 0, date: "", emoticonUrl: "", isBookmarked: false, memoirAnswerList: [])))
            }
            .share()
    }

    private func updateBookmarkStatusObservable(_ trigger: Observable<Void>, _ memoirInquiryResult: Observable<MemoirResponse>) -> Observable<Bool> {
        return trigger
            .withLatestFrom(memoirInquiryResult)
            .flatMapLatest { [weak self] response -> Observable<Bool> in
                guard let self = self, let memoirId = response.result.memoirId else { return .just(false) }
                return self.memoirsService.bookMarkMemoirs(memoirId: memoirId)
                    .map { $0.result.isBookmarked ?? false }
                    .catchAndReturn(false)
            }
    }

    private func reviseMemoirsObservable(_ trigger: Observable<Void>, _ learnedText: Observable<String?>, _ praisedText: Observable<String?>, _ improvementText: Observable<String?>) -> Observable<Bool> {
        return trigger
            .withLatestFrom(Observable.combineLatest(learnedText, praisedText, improvementText))
            .flatMapLatest { [weak self] (learned, praised, improvement) -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                // 여기서 실제 수정 로직 구현, 예제 코드는 단순화를 위해 생략
                return .just(true)
            }
    }
}
