//
//  ExpressedIconViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/28.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// ExpressedIconViewModel
final class ExpressedIconViewModel {
    private let disposeBag = DisposeBag()
    private let memoirsService = MemoirsService()

    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
        let selectedEmoticonId: Observable<Int?>
    }
    
    /// Output
    struct Output {
        let textLength: PublishSubject<Int> = PublishSubject<Int>()
        let moveToNext = PublishSubject<Void>()
        let moveToBack = PublishSubject<Void>()
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        
        /// 완료버튼 클릭
        // startButtonTapped과 selectedEmoticonId를 결합해서 sendMemoirsData 함수에 전달
                Observable.combineLatest(input.startButtonTapped, input.selectedEmoticonId)
                    .flatMapLatest { [weak self] (_, selectedEmoticonId) -> Observable<Bool> in
                        guard let self = self, let emoticonId = selectedEmoticonId else { return .just(false) }
                        return self.sendMemoirsData(emoticonId: emoticonId)
                    }
                    .subscribe(onNext: { success in
                        if success {
                            output.moveToNext.onNext(())
                        }
                    })
                    .disposed(by: disposeBag)
        
        /// 뒤로가기 버튼 클릭
        input.backButtonTapped
            .bind(to: output.moveToBack)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func sendMemoirsData(emoticonId: Int) -> Observable<Bool> {
        let answer1 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer1.rawValue) ?? ""
        let answer2 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer2.rawValue) ?? ""
        let answer3 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer3.rawValue) ?? ""
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: today)
        
        let request = MemoirRequest(
            date: dateString,
            emoticonId: emoticonId, // 이모티콘 ID -> 수정
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
