//
//  NickNameViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

final class NickNameViewModel {
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

        /// 닉네임필드 관찰후 유효문자,길이 판정
        input.nickNameTextChanged
            .map { [weak self] nickName in
                   return (nickName.count, self?.isValidNickName(nickName) ?? false)
               }
            .do(onNext: { (length, isValid) in
                output.isCheckButtonEnabled.accept(length >= 2 && length <= 10 && isValid)
               })
            .map { $0.0 } // 길이만
            .bind(to: output.nickNameLength)
            .disposed(by: disposeBag)

        /// 완료버튼 클릭
        input.startButtonTapped
            .bind { [weak self] in
                self?.moveToProfile()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    /// 정규식을 사용해서 조건에 맞는지 확인
    private func isValidNickName(_ nickName: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9.,!_~]+$"
        return nickName.range(of: regex, options: .regularExpression) != nil
    }
    
    /// 프로필설정으로 이동
    private func moveToProfile() {
        let profileViewModel = ProfileSettingViewModel(navigationController: navigationController)
        let vc = ProfileSettingViewController(viewModel: profileViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
