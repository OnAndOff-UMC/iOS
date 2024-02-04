//
//  BookmarkViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/03.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// BookmarkViewModel
final class BookmarkViewModel {
    
    private let disposeBag = DisposeBag()
    private let navigationController: UINavigationController
    
    /// Input
    struct Input {
        let cellTapped: Observable<String>
    }
    
    /// Output
    struct Output {
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// binding Input
    /// - Parameters:
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) {
        input.cellTapped
            .subscribe(onNext: { [weak self] title in
                print("선택된거 날짜 보여줄꺼임: \(title)")
                self?.moveToMemoirs()
            })
            .disposed(by: disposeBag)
    }

    private func moveToMemoirs() {
        let memoirsViewModel = MemoirsViewModel(navigationController: navigationController)
        let vc = MemoirsViewController(viewModel: memoirsViewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}
