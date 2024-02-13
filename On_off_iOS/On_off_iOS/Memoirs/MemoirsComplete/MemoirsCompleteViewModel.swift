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
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()

        /// 완료버튼 클릭
        input.completedButtonTapped
            .bind { [weak self] in
                self?.moveToImprovement()
            }
            .disposed(by: disposeBag)
        
        /// 뒤로가기 버튼 클릭
        input.backButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                moveToBack()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    /// Memoirs 초기 화면으로 이동
    private func moveToImprovement() {
        
    }
    
    /// 뒤로 이동
    private func moveToBack() {
//        navigationController.popViewController(animated: false)
    }
}


