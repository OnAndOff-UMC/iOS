//
//  MemoirsViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// MemoirsViewModel
final class MemoirsViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    /// Input
    struct Input {
        let bookMarkButtonTapped: Observable<Void>
        let menuButtonTapped: Observable<Void>
        let writeButtonTapped: Observable<Void>
    }
    
    /// Output
    struct Output {
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
        
        /// 북마크 버튼 클릭
        input.bookMarkButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                print("북마크")
            }
            .disposed(by: disposeBag)
        
        /// 메뉴 버튼 클릭
        input.menuButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                print("메뉴 버튼 ")
            }
            .disposed(by: disposeBag)
        
        /// 쓰기버튼 클릭
        input.writeButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                moveTotartToWrite()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    /// 프로필설정으로 이동
    private func moveTotartToWrite() {
        let startToWriteViewModel = StartToWriteViewModel(navigationController: navigationController)
        let vc = StartToWriteViewController(viewModel:startToWriteViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
