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
    
    private let latestMemoirInquiryResult = BehaviorSubject<MemoirResponse?>(value: nil)
    
    // Input 구조체 정의
    struct Input {
        let bookMarkButtonTapped: Observable<Void>
        let menuButtonTapped: Observable<Void>
        let reviseButtonTapped: Observable<Void>
        let memoirInquiry: Observable<Void>
        let toggleEditing: Observable<Void>
        
        // 각 텍스트 필드의 입력을 위한 Observable 추가
        let learnedText: Observable<String?>
        let praisedText: Observable<String?>
        let improvementText: Observable<String?>
    }
    
    // Output 구조체 정의
    struct Output {
        let updateBookmarkStatus: Observable<Bool>
        let memoirInquiryResult: Observable<MemoirResponse>
        let isEditing: Observable<Bool> // 편집 모드 상태
        let reviseResult: Observable<Bool>
        let latestMemoirInquiryResult: Observable<MemoirResponse?>
    }
    
    func bind(input: Input) -> Output {
        
        let isEditingRelay = BehaviorRelay<Bool>(value: false)
        
        // 편집 모드 토글 액션 처리
        input.toggleEditing
            .subscribe(onNext: { _ in
                let currentEditingState = isEditingRelay.value
                isEditingRelay.accept(!currentEditingState)
            })
            .disposed(by: disposeBag)
        
        let reviseResult = input.reviseButtonTapped
            .withLatestFrom(Observable.combineLatest(input.learnedText, input.praisedText, input.improvementText, latestMemoirInquiryResult))
            .flatMapLatest { [weak self] learnedText, praisedText, improvementText, latestResult -> Observable<Bool> in
                guard let self = self, let memoirId = latestResult?.result.memoirId else { return .just(false) }

                // 사용자 입력이 없을 경우 기존 값 사용
                let finalLearnedText = (learnedText?.isEmpty ?? true) ? latestResult?.result.memoirAnswerList.first(where: { $0.summary == "오늘 배운 점" })?.answer ?? "" : learnedText ?? ""
                let finalPraisedText = (praisedText?.isEmpty ?? true) ? latestResult?.result.memoirAnswerList.first(where: { $0.summary == "오늘 칭찬할 점" })?.answer ?? "" : praisedText ?? ""
                let finalImprovementText = (improvementText?.isEmpty ?? true) ? latestResult?.result.memoirAnswerList.first(where: { $0.summary == "앞으로 개선할 점" })?.answer ?? "" : improvementText ?? ""
                
                return self.sendReviceMemoirsData(
                    learnedText: finalLearnedText,
                    praisedText: finalPraisedText,
                    improvementText: finalImprovementText,
                    memoirId: memoirId
                )
            }
        
        /// 회고록 불러오기
        let memoirInquiryResult = input.memoirInquiry
            .flatMapLatest { [weak self] _ -> Observable<MemoirResponse> in
                guard let self = self else { return .empty() }
                return self.memoirsService.inquireMemoirs(date: "2024-02-15")
                    .catchAndReturn(MemoirResponse(isSuccess: false, code: "", message: "", result: MemoirResponse.MemoirResult(memoirId: 0, date: "", emoticonUrl: "", isBookmarked: false, memoirAnswerList: [])))
            }
            .do(onNext: { [weak self] response in
                self?.latestMemoirInquiryResult.onNext(response)
            })
        
        /// 북마크 버튼 탭 처리
        let updateBookmarkStatus = input.bookMarkButtonTapped
            .withLatestFrom(latestMemoirInquiryResult)
            .flatMapLatest { [weak self] latestMemoirResponse -> Observable<Bool> in
                guard let self = self,
                      let memoirId = latestMemoirResponse?.result.memoirId else {
                    return .just(false) // 회고록 ID가 없는 경우 실패 처리
                }
                return self.memoirsService.bookMarkMemoirs(memoirId: memoirId)
                    .map { response -> Bool in
                        return response.result.isBookmarked ?? false
                    }
                    .catchAndReturn(false)
                
            }
        
        return Output(updateBookmarkStatus: updateBookmarkStatus,
                      memoirInquiryResult: memoirInquiryResult,
                      isEditing: isEditingRelay.asObservable(),
                      reviseResult: reviseResult,
                      latestMemoirInquiryResult: latestMemoirInquiryResult.asObservable())
    }
    
    private func sendReviceMemoirsData(learnedText: String, praisedText: String, improvementText: String, memoirId: Int) -> Observable<Bool> {
        let answer1 = learnedText
        let answer2 = praisedText
        let answer3 = improvementText
        let emoticonId = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.emoticonID.rawValue) ?? "1"
        
        let request = MemoirRevisedRequest(
            emoticonId: Int(emoticonId) ?? 1,
            memoirAnswerList: [
                MemoirRevisedRequest.MemoirAnswer(questionId: 1, answer: answer1),
                MemoirRevisedRequest.MemoirAnswer(questionId: 2, answer: answer2),
                MemoirRevisedRequest.MemoirAnswer(questionId: 3, answer: answer3)
            ]
        )
        print("🍎\(memoirId)")
        return memoirsService.reviseMemoirs(request: request, memoirId: memoirId)
            .map { _ -> Bool in true }
            .catchAndReturn(false)
    }
}
