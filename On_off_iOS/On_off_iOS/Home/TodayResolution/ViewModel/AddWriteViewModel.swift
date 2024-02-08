//
//  AddWriteViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/6/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class AddWriteViewModel {
    
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    struct Input {
        let backButton: Observable<Void>
        let saveButton: Observable<Void>
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func bind(input: Input) {
        /// 뒤로가기 버튼 클릭
        input.backButton
            .bind { [weak self] in
                guard let self = self else { return }
                moveToBack()
            }
            .disposed(by: disposeBag)
        
    }
    
    /// 뒤로 이동 - animate 제거
    private func moveToBack() {
        navigationController.popViewController(animated: true)
    }
    
    
    
}
