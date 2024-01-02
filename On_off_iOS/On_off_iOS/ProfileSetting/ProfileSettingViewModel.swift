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

final class ProfileSettingViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    struct Input {
        let startButtonTapped: Observable<Void>
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
