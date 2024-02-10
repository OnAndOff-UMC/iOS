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

    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let jumpButtonTapped: Observable<Void>
    }

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// bind
    /// - Parameter input:startButtonTapped, jumpButtonTapped
    func bind(input: Input) {
        input.startButtonTapped
                .bind { [weak self] in
                    self?.moveToLogin()
                }
                .disposed(by: disposeBag)
        
        input.jumpButtonTapped
                .bind { [weak self] in
                    self?.moveToLogin()
                }
                .disposed(by: disposeBag)
    }
    
    /// 로그인 화면으로 이동
    private func moveToLogin() {
        let loginService = LoginService()

        // LoginViewModel에 signInService 전달
        let loginViewModel = LoginViewModel(navigationController: navigationController, loginService: loginService)
        let vc = LoginViewController(viewModel: loginViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
