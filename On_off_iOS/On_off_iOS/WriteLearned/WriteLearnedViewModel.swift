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
    var navigationController: UINavigationController

    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let textChanged: Observable<String>
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

        /// textLength
        input.textChanged
            .map { $0.count }
            .bind(to: output.textLength)
            .disposed(by: disposeBag)

        /// 완료버튼 클릭
        input.startButtonTapped
            .bind { [weak self] in
                self?.moveToImprovement()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    /// Improvement 화면으로 이동
    private func moveToImprovement() {
        let writeImprovementViewModel = WriteImprovementViewModel(navigationController: navigationController)
        let vc = WriteImprovementViewController(viewModel: writeImprovementViewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}
