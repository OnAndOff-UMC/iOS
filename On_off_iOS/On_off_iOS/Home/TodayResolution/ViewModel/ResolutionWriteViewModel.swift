//
//  ResolutionWriteViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/4/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class ResolutionWriteViewModel {
    
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    let showMenuModal = PublishSubject<Void>()
    
    struct Input {
        let backButton: Observable<Void>
        let menuButton: Observable<Void>
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// bind
    /// - Parameter input:
    func bind(input: Input) {
        /// 뒤로가기 버튼 클릭
        input.backButton
            .bind { [weak self] in
                guard let self = self else { return }
                moveToBack()
            }
            .disposed(by: disposeBag)
        /// 메뉴로 이동 버튼 클릭
        input.menuButton
            .bind { [weak self] in
                guard let self = self else { return }
                moveToMenu()
            }
            .disposed(by: disposeBag)
        
    }
    
    /// 뒤로 이동 - animate 제거
    private func moveToBack() {
        navigationController.popViewController(animated: true)
    }
    
    // menu버튼 누르면 modal 뜨게
    private func moveToMenu() {
        showMenuModal.onNext(())
    }
    
    
}
