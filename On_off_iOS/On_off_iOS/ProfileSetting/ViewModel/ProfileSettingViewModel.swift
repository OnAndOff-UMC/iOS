//
//  ProfileSettingViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// ProfileSettingViewModel
final class ProfileSettingViewModel {
    private let disposeBag = DisposeBag()
    private var navigationController: UINavigationController
    
    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    func bind(input: Input) {
        
        /// 시작 버튼 클릭
        input.startButtonTapped
            .bind { [weak self] in
                self?.moveToSelectTime()
            }
            .disposed(by: disposeBag)
    }
    
    /// 프로필설정으로 이동
    private func moveToSelectTime() {
        let selectTimeViewModel = SelectTimeViewModel(navigationController: navigationController)
        let vc = SelectTimeViewController(viewModel: selectTimeViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
