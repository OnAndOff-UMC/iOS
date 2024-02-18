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
        let nicknameValidationTrigger: Observable<String>
    }
    
    /// Output
    struct Output {
        let nickNameFilteringRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        let nickNameLength: PublishSubject<Int> = PublishSubject<Int>()
        let isCheckButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
        let moveToNext = PublishSubject<Void>()
        
        let nicknameValidationResult: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)// 닉네임이 유효한지
        let nicknameValidationMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "") // 검증에 따른 메시지
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
        
        // 닉네임 길이 관찰
               input.nickNameTextChanged
                   .map { $0.count }
                   .bind(to: output.nickNameLength)
                   .disposed(by: disposeBag)

               // 중복 검사 및 유효성 검사
               input.nickNameTextChanged
                   .flatMapLatest { [unowned self] nickname in
                       return self.nickNameService.nicknameDuplicate(nickname: nickname)
                           
                   }
                   .subscribe(onNext: { response in
                       let isValid = response.isSuccess ?? false && (response.message == "사용 가능한 닉네임입니다.")
                       output.isCheckButtonEnabled.accept(isValid)
                       output.nicknameValidationMessage.accept(response.message ?? "사용 불가능합니다")
                   }).disposed(by: disposeBag)
        
        /// 닉네임필드 관찰후 유효문자,길이 판정
        observeNickNameTextChanged(input.nickNameTextChanged, output: output)
        
        /// 완료버튼 클릭
        handleStartButtonTapped(input.startButtonTapped, nickNameTextChanged: input.nickNameTextChanged, output: output)
        
        return output
    }
    
    ///글자수 세기
    private func observeNickNameLengthTextChanged(_ nickNameTextChanged: Observable<String>, output: Output) {
        nickNameTextChanged
            .map { $0.count }
            .bind(to: output.nickNameLength)
            .disposed(by: disposeBag)
    }

    
    private func observeNickNameTextChanged(_ nickNameTextChanged: Observable<String>, output: Output) {
        nickNameTextChanged
            .flatMapLatest { [unowned self] nickname -> Observable<(Bool, String, Int)> in
                // 글자수 검사
                let isValidLength = nickname.count >= 2 && nickname.count <= 10
                if !isValidLength {
                    return .just((false, "사용 불가능한 닉네임입니다.", nickname.count))
                }
                
                // 닉네임 유효성 검사
                let isValidNickName = self.isValidNickName(nickname)
                if !isValidNickName {
                    return .just((false, "사용 불가능한 닉네임입니다.", nickname.count))
                }

                // 중복 검사 수행
                return self.nickNameService.nicknameDuplicate(nickname: nickname)
                    .map { response in
                        let isSuccess = response.isSuccess ?? false
                        let message = isSuccess ? "사용 가능한 닉네임입니다." : "이미 사용 중인 닉네임입니다."
                        return (isSuccess, message, nickname.count)
                    }
                    .catchAndReturn((false, "이미 사용 중인 닉네임입니다.", nickname.count))
            }
            .subscribe(onNext: { isValid, message, length in
                      output.nicknameValidationResult.accept(isValid)
                      output.nicknameValidationMessage.accept(message)
                      output.nickNameLength.onNext(length)
                  })
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
