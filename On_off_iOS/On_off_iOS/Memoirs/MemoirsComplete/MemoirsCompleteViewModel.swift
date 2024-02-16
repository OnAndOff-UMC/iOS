//
//  MemoirsCompleteViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/29.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

// MemoirsCompleteViewModel
final class MemoirsCompleteViewModel {
    private let disposeBag = DisposeBag()

    /// Input
    struct Input {
        let completedButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    /// Output
    struct Output {
        let textLength: PublishSubject<Int> = PublishSubject<Int>()
        let moveToNext = PublishSubject<Void>()
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()

        moveToImprovement(input, output)
        
        return output
    }
    
    /// Memoirs 초기 화면으로 이동
    private func moveToImprovement(_ input: MemoirsCompleteViewModel.Input, _ output: MemoirsCompleteViewModel.Output) {
        
        input.completedButtonTapped
            .bind { [weak self] in
                output.moveToNext.onNext(())
            }
            .disposed(by: disposeBag)
    }
}


