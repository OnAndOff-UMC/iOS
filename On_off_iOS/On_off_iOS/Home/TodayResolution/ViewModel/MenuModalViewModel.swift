//
//  MenuModalViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/5/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class MenuModalViewModel {
    
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
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
//        /// 추가하기 버튼
//        input.addButton
//            .bind { [weak self] in
//                guard let self = self else { return }
//                
//            }
//            .disposed(by: disposeBag)
//        /// 수정하기 버튼
//        input.modifyButton
//            .bind { [weak self] in
//                guard let self = self else { return }
//                
//            }
//            .disposed(by: disposeBag)
//        /// 수정하기 버튼
//        input.removeButton
//            .bind { [weak self] in
//                guard let self = self else { return }
//                
//            }
//            .disposed(by: disposeBag)
        
    }
    
    
    
    
}
