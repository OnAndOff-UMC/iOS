//
//  StartToWriteViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// StartToWriteViewModel
final class StartToWriteViewModel {
    private let disposeBag = DisposeBag()
    
    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    /// Output
    struct Output {
        let moveToNext = PublishSubject<Void>()
        let moveToBack = PublishSubject<Void>()
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        
        /// 시작하기 버튼 클릭
        input.startButtonTapped
            .bind(to: output.moveToNext)
            .disposed(by: disposeBag)
        
        /// 뒤로가기 버튼 클릭
        input.backButtonTapped
            .bind(to: output.moveToBack)
            .disposed(by: disposeBag)
        
        return output
    }
}
