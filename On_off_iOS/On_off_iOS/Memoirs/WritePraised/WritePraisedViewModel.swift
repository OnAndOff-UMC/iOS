//
//  WritePraisedViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// WritePraisedViewModel
final class WritePraisedViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let textChanged: Observable<String>
        let backButtonTapped: Observable<Void>
    }
    
    /// Output
    struct Output {
        let textLength: PublishSubject<Int> = PublishSubject<Int>()
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
        
        /// textLength
        input.textChanged
            .map { $0.count }
            .bind(to: output.textLength)
            .disposed(by: disposeBag)
        
        /// 완료버튼 클릭
        input.startButtonTapped
            .withLatestFrom(input.textChanged)
            .take(1)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                
                // 키체인에 저장
                let isSuccess = KeychainWrapper.saveItem(value: text, forKey: MemoirsKeyChain.MemoirsAnswer3.rawValue)
                
                if isSuccess {
                    self.moveToExpressedIcon()
                } else {
                    // 오류 처리할거임
                }
            }).disposed(by: disposeBag)
        
        /// 뒤로가기 버튼 클릭
        input.backButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                moveToBack()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    /// Memoirs 초기 화면으로 이동
    private func moveToExpressedIcon() {
        let expressedIconViewModel = ExpressedIconViewModel(navigationController: navigationController)
        let vc = ExpressedIconViewController(viewModel: expressedIconViewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
    /// 뒤로 이동 - animate 제거
    private func moveToBack() {
        navigationController.popViewController(animated: false)
    }
}
