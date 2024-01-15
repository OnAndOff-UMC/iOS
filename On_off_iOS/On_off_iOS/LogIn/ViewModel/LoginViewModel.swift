//
//  LoginViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class LoginViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController

    struct Input {
        let kakaoButtonTapped: Observable<Void>
        let appleButtonTapped: Observable<Void>
    }

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func bind(input: Input) {
        input.kakaoButtonTapped
                .bind { [weak self] in
                    self?.moveToNickName()
                }
                .disposed(by: disposeBag)
        
        input.appleButtonTapped
                .bind { [weak self] in
                    self?.moveToNickName()
                }
                .disposed(by: disposeBag)
    }
    
    private func moveToNickName() {
        let vc = NickNameViewController(viewModel: NickNameViewModel(navigationController: navigationController))
        navigationController.pushViewController(vc, animated: true)
    }
}

