//
//  SelectTimeViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/18.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// SelectTimeViewModel
final class SelectTimeViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let nickNameTextChanged: Observable<String>
    }
    
    /// Output
    struct Output {
        let nickNameFilteringRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        let nickNameLength: PublishSubject<Int> = PublishSubject<Int>()
        let isCheckButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        return output
    }
}
