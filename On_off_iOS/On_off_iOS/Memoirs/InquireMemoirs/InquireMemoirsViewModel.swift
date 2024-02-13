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
    private let currentMemoirResponse = BehaviorRelay<MemoirResponse?>(value: nil)
    
    private let initialLearnedText = BehaviorRelay<String?>(value: nil)
    private let initialPraisedText = BehaviorRelay<String?>(value: nil)
    private let initialImprovementText = BehaviorRelay<String?>(value: nil)
    // Input 구조체 정의
    struct Input {
        let bookMarkButtonTapped: Observable<Void>
        let menuButtonTapped: Observable<Void>
        let reviseButtonTapped: Observable<Void>
        let memoirId: Int
        let memoirInquiry: Observable<Void>
        let toggleEditing: Observable<Void>
        // let revisedMemoirData: Observable<(learnedText: String, praisedText: String, improvementText: String)>
        //let deleteButtonTapped: Observable<Void>
        
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
    }
    
    func bind(input: Input) -> Output {
        
        let isEditingRelay = BehaviorRelay<Bool>(value: false)
        
        // 각 입력 필드에 대한 처리
        
        
        // 편집 모드 토글 액션 처리
        input.toggleEditing
            .subscribe(onNext: { _ in
                let currentEditingState = isEditingRelay.value
                isEditingRelay.accept(!currentEditingState)
            })
            .disposed(by: disposeBag)
        
        // 완료 버튼 탭
        let reviseResult = input.reviseButtonTapped
            .withLatestFrom(Observable.combineLatest(input.learnedText.startWith(self.initialLearnedText.value),
                                                     input.praisedText.startWith(self.initialPraisedText.value),
                                                     input.improvementText.startWith(self.initialImprovementText.value)))
            .flatMapLatest { [weak self] learnedText, praisedText, improvementText -> Observable<Bool> in
                
                /// 비어있지 않은 값 사용 또는 초기 값으로 대체
                let finalLearnedText = ((learnedText?.isEmpty) == nil) ? learnedText : self?.initialLearnedText.value ?? ""
                let finalPraisedText = ((praisedText?.isEmpty) == nil) ? praisedText : self?.initialPraisedText.value ?? ""
                let finalImprovementText = ((improvementText?.isEmpty) == nil) ? improvementText : self?.initialImprovementText.value ?? ""
                
                return self?.sendReviceMemoirsData(
                    learnedText: finalLearnedText ?? "",
                    praisedText: finalPraisedText ?? "",
                    improvementText: finalImprovementText ?? "",
                    memoirId: input.memoirId
                ) ?? .just(false)
            }
        
        /// 회고록 불러오기
        let memoirInquiryResult = input.memoirInquiry
            .flatMapLatest { [weak self] _ -> Observable<MemoirResponse> in
                guard let self = self else { return .empty() }
                
                // "2024-02-12" 날짜를 사용하여 회고록 조회
                return self.memoirsService.inquireMemoirs(date: "2024-02-13")
                    .catchAndReturn(MemoirResponse(isSuccess: false, code: "", message: "", result: MemoirResponse.MemoirResult(memoirId: 0, date: "", emoticonUrl: "", isBookmarked: false, memoirAnswerList: [])))
            }
        
        /// 북마크 버튼 탭 처리
        let updateBookmarkStatus = input.bookMarkButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                
                return self.memoirsService.bookMarkMemoirs(memoirId: input.memoirId)
                    .map { response -> Bool in
                        return response.result.isBookmarked
                    }
                    .catchAndReturn(false)
            }
        
        return Output(updateBookmarkStatus: updateBookmarkStatus,
                      memoirInquiryResult: memoirInquiryResult,
                      isEditing: isEditingRelay.asObservable(),
                      reviseResult: reviseResult)
    }
    
    private func sendReviceMemoirsData(learnedText: String, praisedText: String, improvementText: String, memoirId: Int) -> Observable<Bool> {
        let answer1 = learnedText
        let answer2 = praisedText
        let answer3 = improvementText
        let emoticonId = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.emoticonID.rawValue) ?? "1"
        
        let request = MemoirRevisedRequest(
            emoticonId: Int(emoticonId) ?? 1,
            memoirAnswerList: [
                MemoirRevisedRequest.MemoirAnswer(answerId: 1, answer: answer1),
                MemoirRevisedRequest.MemoirAnswer(answerId: 2, answer: answer2),
                MemoirRevisedRequest.MemoirAnswer(answerId: 3, answer: answer3)
            ]
        )
        print(request)
        print(memoirId)
        return memoirsService.reviseMemoirs(request: request, memoirId: memoirId)
            .map { _ -> Bool in true }
            .catchAndReturn(false)
    }
}
