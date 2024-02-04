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
    
    struct Input {
        
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// bind
    /// - Parameter input: kakaoButtonTapped, appleButtonTapped
    func bind(input: Input) {
//        input.kakaoButtonTapped
//                .bind { [weak self] in
//                    self?.moveToNickName()
//                }
//                .disposed(by: disposeBag)
//
//        input.appleButtonTapped
//                .bind { [weak self] in
//                    self?.moveToNickName()
//                }
//                .disposed(by: disposeBag)
    }
    
    
}
