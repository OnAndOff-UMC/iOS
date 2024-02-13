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
        let reviceButtonTapped: Observable<Void>
        let memoirId: Int
        let memoirInquiry: Observable<Void>
        let toggleEditing: Observable<Void>
    }
    
    // Output 구조체 정의
    struct Output {
        let updateBookmarkStatus: Observable<Bool>
        let memoirInquiryResult: Observable<MemoirResponse>
        let isEditing: Observable<Bool> // 편집 모드 상태
    }
    
    // Input을 받아 Output을 반환하는 bind 함수
    func bind(input: Input) -> Output {
        
        let isEditingRelay = BehaviorRelay<Bool>(value: false) // 편집 상태 관리를 위한 Relay

        let memoirInquiryResult = input.memoirInquiry
            .flatMapLatest { [weak self] _ -> Observable<MemoirResponse> in
                guard let self = self else { return .empty() }
                // "2024-02-12" 날짜를 사용하여 회고록 조회
                return self.memoirsService.inquireMemoirs(date: "2024-02-12")
                    .catchAndReturn(MemoirResponse(isSuccess: false, code: "", message: "", result: MemoirResponse.MemoirResult(memoirId: 0, date: "", emoticonUrl: "", isBookmarked: false, memoirAnswerList: [])))
            }
        
        // 북마크 버튼 탭 처리
        let updateBookmarkStatus = input.bookMarkButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                // memoId를 직접 사용
                return self.memoirsService.bookMarkMemoirs(memoirId: input.memoirId)
                    .map { response -> Bool in
                        return response.result.isBookmarked
                    }
                    .catchAndReturn(false)
            }

        // 편집 모드 토글 액션 처리
              input.toggleEditing
                  .subscribe(onNext: { _ in
                      let currentEditingState = isEditingRelay.value
                      isEditingRelay.accept(!currentEditingState)
                  })
                  .disposed(by: disposeBag)
        
        return Output(updateBookmarkStatus: updateBookmarkStatus,
                      memoirInquiryResult: memoirInquiryResult,
                      isEditing: isEditingRelay.asObservable())
    }
    
    
    private func sendReviceMemoirsData() -> Observable<Bool> {
        let answer1 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer1.rawValue) ?? ""
        let answer2 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer2.rawValue) ?? ""
        let answer3 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer3.rawValue) ?? ""
        let emoticonId = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.emoticonID.rawValue) ?? "1"
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: today)
        
        let request = MemoirRequest(
            date: dateString,
            emoticonId: Int(emoticonId) ?? 1,
            memoirAnswerList: [
                MemoirRequest.MemoirAnswer(questionId: 1, answer: answer1),
                MemoirRequest.MemoirAnswer(questionId: 2, answer: answer2),
                MemoirRequest.MemoirAnswer(questionId: 3, answer: answer3)
            ]
        )
        return memoirsService.saveMemoirs(request: request)
            .map { _ -> Bool in true }
            .catchAndReturn(false)
    }
}
