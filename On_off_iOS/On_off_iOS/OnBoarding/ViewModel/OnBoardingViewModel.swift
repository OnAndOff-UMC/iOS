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
    var navigationController: UINavigationController

    struct Input {
        let startButtonTapped: Observable<Void>
    }

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func bind(input: Input) {
        input.startButtonTapped
                .bind { [weak self] in
                    self?.moveToLogin()
                }
                .disposed(by: disposeBag)
    }
    
    private func moveToLogin() {
        let loginViewModel = LoginViewModel(navigationController: navigationController)
        let vc = LoginViewController(viewModel: loginViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
