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
    var navigationController: UINavigationController

    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    /// Output
    struct Output {
        let textLength: PublishSubject<Int> = PublishSubject<Int>()
    }

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()

        /// 완료버튼 클릭
        input.startButtonTapped
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
        navigationController.popViewController(animated: false)
    }
}

