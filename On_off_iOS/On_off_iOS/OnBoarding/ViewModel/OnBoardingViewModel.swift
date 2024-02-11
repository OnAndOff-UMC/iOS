//
//  OnBoardingViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class OnBoardingViewModel {
    private let disposeBag = DisposeBag()

    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let jumpButtonTapped: Observable<Void>
    }
    
    /// Output
    struct Output {
        let moveToLogin = PublishSubject<Void>()
    }
    
    /// bind
    /// - Parameter input:startButtonTapped, jumpButtonTapped
    func bind(input: Input) -> Output {
        let output = Output()
        
        input.startButtonTapped
                .bind { _ in
                    output.moveToLogin.onNext(())
                }
                .disposed(by: disposeBag)
        
        input.jumpButtonTapped
                .bind { _ in
                    output.moveToLogin.onNext(())
                }
                .disposed(by: disposeBag)
        
        return output
    }
}
