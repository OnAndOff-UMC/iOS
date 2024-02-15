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
        
        // 각 텍스트 필드의 입력을 위한 Observable 추가
        let learnedText: Observable<String?>
        let praisedText: Observable<String?>
        let improvementText: Observable<String?>
        
        let selectedDateEvents: Observable<String>
    }
    
    // Output 구조체 정의
    struct Output {
        let updateBookmarkStatus: PublishRelay<Bool> = PublishRelay()
        let memoirInquiryResult: BehaviorRelay<MemoirResponse?> = BehaviorRelay(value: nil)
        let isEditing: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let reviseResult: PublishRelay<Bool> = PublishRelay()
        let selectedDate: BehaviorRelay<String> = BehaviorRelay(value: "")
    }
    
    func bind(input: Input) -> Output {
        let output = Output()
        
        bindToggleEditing(input: input, output: output)
        bindSelectedDateEvents(input: input, output: output)
        bindMemoirInquiry(input: input, output: output)
        bindBookMarkButtonTapped(input: input, output: output)
        bindReviseButtonTapped(input: input, output: output)
        
        return output
    }
    
    /// Bind Revise Button Tapped
    private func bindReviseButtonTapped(input: Input, output: Output) {
        input.reviseButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                bindDoneButton(input: input, output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Done Button
    private func bindDoneButton(input: Input, output: Output) {
        Observable.combineLatest(input.learnedText, input.praisedText, input.improvementText)
            .bind { [weak self] learnedText, praisedText, improvementText in
                guard let self = self, let memoirId = output.memoirInquiryResult.value?.result.memoirId else { return }
                sendReviceMemoirsData(memoirAnswerList: [MemoirRevisedRequest.MemoirAnswer(questionId: 1, answer: checkingTextResult(text: learnedText, summary: "오늘 배운 점", output: output)),
                                                         MemoirRevisedRequest.MemoirAnswer(questionId: 2, answer: checkingTextResult(text: praisedText, summary: "오늘 칭찬할 점", output: output)),
                                                         MemoirRevisedRequest.MemoirAnswer(questionId: 3, answer: checkingTextResult(text: improvementText, summary: "앞으로 개선할 점", output: output))],
                                      memoirId: memoirId,
                                      output: output)
                
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Toggle Editing
    private func bindToggleEditing(input: Input, output: Output) {
        // 편집 모드 토글 액션 처리
        input.toggleEditing
            .subscribe(onNext: { _ in
                output.isEditing.accept(!output.isEditing.value)
            })
            .disposed(by: disposeBag)
    }
    
    /// Binding Book Mark Button Tapped
    private func bindBookMarkButtonTapped(input: Input, output: Output) {
        input.bookMarkButtonTapped
            .bind {  [weak self] _ in
                guard let self = self, let memoirId = output.memoirInquiryResult.value?.result.memoirId else { return }
                getUpdateBookmarkStatus(memoirId: memoirId, output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Memoir Inquiry
    private func bindMemoirInquiry(input: Input, output: Output) {
        input.memoirInquiry
            .bind { [weak self] _ in
                guard let self = self else { return }
                getMemoirInquiryResult(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Selected Date Events
    private func bindSelectedDateEvents(input: Input, output: Output) {
        input.selectedDateEvents
            .bind(to: output.selectedDate)
            .disposed(by: disposeBag)
    }
    
    /// Get Update Book Mark Status
    private func getUpdateBookmarkStatus(memoirId: Int, output: Output) {
        memoirsService.bookMarkMemoirs(memoirId: memoirId)
            .subscribe(onNext: { result in
                output.updateBookmarkStatus.accept(result.result.isBookmarked ?? false)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// Get memoir Inquiry Result
    private func getMemoirInquiryResult(output: Output) {
        memoirsService.inquireMemoirs(date: output.selectedDate.value)
            .subscribe(onNext: { result in
                output.memoirInquiryResult.accept(result)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 입력한 값이 빈 경우 확인 하는 함수
    /// - Parameters:
    ///   - text: 사용자가 입력한 문구
    ///   - summary: 어떤 부분의 내용인지
    /// - Returns: 사용자가 문구를 입력했는지 확인한 후 없는 경우 기존 값 사용
    private func checkingTextResult(text: String?, summary: String, output: Output) -> String {
        if text?.isEmpty ?? true {
            return output.memoirInquiryResult.value?.result.memoirAnswerList.first(where: { $0.summary == summary })?.answer ?? ""
        }
        return text ?? ""
    }
    
    /// Send Revice Memoirs Data
    private func sendReviceMemoirsData(memoirAnswerList: [MemoirRevisedRequest.MemoirAnswer], memoirId: Int, output: Output) {
        let emoticonId = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.emoticonID.rawValue) ?? "1"
        
        let request = MemoirRevisedRequest(
            emoticonId: Int(emoticonId) ?? 1,
            memoirAnswerList: memoirAnswerList
        )
        
        memoirsService.reviseMemoirs(request: request, memoirId: memoirId)
            .subscribe(onNext: { result in
                output.reviseResult.accept(result.isSuccess)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
