//
//  NickNameViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class NickNameViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController

    struct Input {
           let startButtonTapped: Observable<Void>
         //  let nickNameTextChanged: Observable<String>
       }

       let isNicknameValid = PublishRelay<Bool>()
    struct Output {
        
    }


    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func bind(input: Input) {
        input.startButtonTapped
                .bind { [weak self] in
                    self?.moveToProfile()
                }
                .disposed(by: disposeBag)
    }
    
    private func moveToProfile() {
        let profileViewModel = ProfileSettingViewModel(navigationController: navigationController)
        let vc = ProfileSettingViewController(viewModel: profileViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
