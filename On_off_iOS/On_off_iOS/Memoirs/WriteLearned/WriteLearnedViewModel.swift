//
//  WriteLearnedViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// WriteLearnedViewModel
final class WriteLearnedViewModel {
    private let disposeBag = DisposeBag()
    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let textChanged: Observable<String>
        let backButtonTapped: Observable<Void>

    }
    
    struct Output {
        let textLength = PublishSubject<Int>()
        let saveResult = PublishSubject<Bool>() // 저장 성공 여부를 나타내는 PublishSubject
        let moveToBack = PublishSubject<Void>()
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()

        /// textLength
        input.textChanged
            .map { $0.count }
            .bind(to: output.textLength)
            .disposed(by: disposeBag)

        input.startButtonTapped
                .withLatestFrom(input.textChanged)
                .subscribe(onNext: { text in
                    let isSuccess = KeychainWrapper.saveItem(value: text, forKey: MemoirsKeyChain.MemoirsAnswer1.rawValue)
                    output.saveResult.onNext(isSuccess)
                }).disposed(by: disposeBag)
        
        /// 뒤로가기 버튼 클릭
        input.backButtonTapped
            .bind(to: output.moveToBack)
            .disposed(by: disposeBag)
        
        return output
    }
}
