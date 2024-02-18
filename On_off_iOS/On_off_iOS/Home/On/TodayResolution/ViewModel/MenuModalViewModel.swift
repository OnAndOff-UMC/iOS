//
//  MenuModalViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class MenuModalViewModel {
    
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    let showAddModal = PublishSubject<Void>()
    
    struct Input {
        let addButton: Observable<Void>
        let modifyButton: Observable<Void>
        let removeButton: Observable<Void>
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// bind
    /// - Parameter input:
    func bind(input: Input) {
        /// 추가하기 버튼
        input.addButton
            .bind { [weak self] in
                guard let self = self else { return }
                self.navigationController.dismiss(animated: true, completion: nil)
                movetoAddView()
            }.disposed(by: disposeBag)
        
        
        /// 수정하기 버튼
        input.modifyButton
            .bind { [weak self] in
                guard let self = self else { return }
                self.navigationController.dismiss(animated: true, completion: nil)
                movetoModifyView()
            }.disposed(by: disposeBag)
        
        /// 제거하기 버튼
        input.removeButton
            .bind { [weak self] in
                guard let self = self else { return }
                self.navigationController.dismiss(animated: true, completion: nil)
                movetoRemoveView()
            }.disposed(by: disposeBag)
        
    }
    
    /// 추가하기 버튼 누르면 이동할 View
    private func movetoAddView() {
        let vc = AddWriteViewController(viewModel: AddWriteViewModel(navigationController: navigationController))
        navigationController.pushViewController(vc, animated: true)
    }
    
    /// 수정하기 버튼 누르면 이동할 View
    private func movetoModifyView() {
        navigationController.popViewController(animated: true)
    }
    
    /// 삭제하기 버튼 누르면 이동할 View
    private func movetoRemoveView() {
        navigationController.popViewController(animated: true)
    }
    
}
