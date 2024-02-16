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
        let moveToNext = PublishSubject<Void>()
    }
    
    /// binding Input
    /// - Parameter 
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        
        /// 닉네임필드 관찰후 유효문자,길이 판정
        observeNickNameTextChanged(input.nickNameTextChanged, output: output)
        
        /// 완료버튼 클릭
        handleStartButtonTapped(input.startButtonTapped, nickNameTextChanged: input.nickNameTextChanged, output: output)
        
        return output
    }
    
    private func observeNickNameTextChanged(_ nickNameTextChanged: Observable<String>, output: Output) {
        nickNameTextChanged
            .map { [weak self] nickName in
                return (nickName.count, self?.isValidNickName(nickName) ?? false)
            }
            .do(onNext: { (length, isValid) in
                output.isCheckButtonEnabled.accept(length >= 2 && length <= 10 && isValid)
            })
            .map { $0.0 } // Only length
            .bind(to: output.nickNameLength)
            .disposed(by: disposeBag)
    }
    
    private func handleStartButtonTapped(_ startButtonTapped: Observable<Void>, nickNameTextChanged: Observable<String>, output: Output) {
        startButtonTapped
            .withLatestFrom(nickNameTextChanged)
            .subscribe(onNext: { nickname in
                _ = KeychainWrapper.saveItem(value: nickname, forKey: ProfileKeyChain.nickname.rawValue)
                output.moveToNext.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    /// 정규식을 사용해서 조건에 맞는지 확인
    private func isValidNickName(_ nickName: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9.,!_~]+$"
        return nickName.range(of: regex, options: .regularExpression) != nil
    }
}
