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
        /// 저장 성공 여부를 나타내는 PublishSubject
        let saveResult = PublishSubject<Bool>()
        let moveToBack = PublishSubject<Void>()
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        
        /// 각 바인딩 메소드
        bindEvents(input, output)
        
        return output
    }
    
    private func bindEvents(_ input: WriteLearnedViewModel.Input, _ output: WriteLearnedViewModel.Output) {
        
        /// text 변화감지
        bindTextChanged(input, output)
        
        /// 시작하기 버튼 클릭
        bindStartButtonTapped(input, output)
        
        /// 뒤로가기 버튼 클릭
        bindBackButtonTapped(input, output)
    }
    
    private func bindTextChanged(_ input: WriteLearnedViewModel.Input, _ output: WriteLearnedViewModel.Output) {
        input.textChanged
            .map { $0.count }
            .bind(to: output.textLength)
            .disposed(by: disposeBag)
    }
    
    private func bindStartButtonTapped(_ input: WriteLearnedViewModel.Input, _ output: WriteLearnedViewModel.Output) {
        input.startButtonTapped
                .withLatestFrom(input.textChanged)
                .subscribe(onNext: { text in
                    let isSuccess = KeychainWrapper.saveItem(value: text, forKey: MemoirsKeyChain.MemoirsAnswer1.rawValue)
                    output.saveResult.onNext(isSuccess)
                }).disposed(by: disposeBag)
    }
    
    private func bindBackButtonTapped(_ input: WriteLearnedViewModel.Input, _ output: WriteLearnedViewModel.Output) {
        input.backButtonTapped
            .bind(to: output.moveToBack)
            .disposed(by: disposeBag)
    }
}
