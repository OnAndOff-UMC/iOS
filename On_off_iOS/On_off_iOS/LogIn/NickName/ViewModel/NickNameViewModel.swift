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
    private let nickNameService: NickNameService
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
    
    // MARK: - Init
    init(nickNameService: NickNameService) {
        self.nickNameService = nickNameService
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
    
    ///글자수 세
    private func observeNickNameLengthTextChanged(_ nickNameTextChanged: Observable<String>, output: Output) {
        nickNameTextChanged
            .map { $0.count }
            .bind(to: output.nickNameLength)
            .disposed(by: disposeBag)
    }

    private func observeNickNameTextChanged(_ nickNameTextChanged: Observable<String>, output: Output) {
        nickNameTextChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] nickName in
                // 닉네임 길이 업데이트
                
                output.nickNameLength.onNext(nickName.count)
                
                let isValidLength = nickName.count >= 2 && nickName.count <= 10
                let isValidNickName = self?.isValidNickName(nickName) ?? false
                let isValid = isValidLength && isValidNickName
                
                /// 닉네임 유효성 검사 결과에 따라 버튼 활성화 상태 업데이트
                output.isCheckButtonEnabled.accept(isValid)
                
                if isValid {
                    /// 닉네임 중복 검사
                    self?.checkNickNameDuplicate(nickName, output: output)
                }
            }).disposed(by: disposeBag)
    }

    private func checkNickNameDuplicate(_ nickName: String, output: Output) {
        nickNameService.nicknameDuplicate(nickname: nickName)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                let isSuccess = response.isSuccess ?? false
                let isAvailable = isSuccess && (response.result == "사용 가능한 닉네임입니다.")

                output.isCheckButtonEnabled.accept(isAvailable)
                if !isSuccess {

                    print(response.message ?? "오류 발생")
                }
            }, onError: { error in
                print("네트워크 오류")

            }).disposed(by: disposeBag)
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
