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
    var navigationController: UINavigationController

    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
       }
    
    /// Output
    struct Output {
    
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

        /// 시작하기 버튼 클릭
        input.startButtonTapped
            .bind { [weak self] in
                self?.moveToWriteLearned()
            }
            .disposed(by: disposeBag)
        
        return output
    }

    /// WriteLearnedViewController으로 이동
    private func moveToWriteLearned() {
        let writeLearnedViewModel = WriteLearnedViewModel(navigationController: navigationController)
        let vc = WriteLearnedViewController(viewModel: writeLearnedViewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}
