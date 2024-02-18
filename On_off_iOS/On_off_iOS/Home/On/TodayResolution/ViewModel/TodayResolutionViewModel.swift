//
//  TodayResolutionViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class TodayResolutionViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    struct Input {
        let buttonTapped: Observable<Void>
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// bind
    /// - Parameter input: kakaoButtonTapped, appleButtonTapped
    func bind(input: Input) {
        input.buttonTapped
                .bind { [weak self] in
                    self?.moveToWriteView()
                }
                .disposed(by: disposeBag)
        
    }
    
    /// 작성화면으로 이동
    private func moveToWriteView() {
        let vc = ResolutionWriteViewController(viewModel: ResolutionWriteViewModel(navigationController: navigationController))
        navigationController.pushViewController(vc, animated: true)
    }
}
