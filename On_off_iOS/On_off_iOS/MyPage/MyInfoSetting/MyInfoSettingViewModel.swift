//
//  MyInfoSettingViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/17.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// MyInfoSettingViewModel
final class MyInfoSettingViewModel: MyInfoSettingProtocol {
    private let disposeBag = DisposeBag()
    private let myInfoSettingService: MyInfoSettingService
    
    /// Input
    struct Input {
        let saveButtonTapped: PublishSubject<Void> = PublishSubject<Void>()
        let jobTextChanged: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        let nickNameTextChanged: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        let fieldOfWorkSelected: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
        let experienceYearSelected: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    }
    
    
    /// Output
    struct Output {
        /// 초기에 불러올 값
        var nickNameRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var jobRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var fieldOfWorkRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var experienceYearRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        
        let nickNameFilteringRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        let nickNameLength: PublishSubject<Int> = PublishSubject<Int>()
        let nicknameValidationResult: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)// 닉네임이 유효한지
        let nicknameValidationMessage: BehaviorRelay<String> = BehaviorRelay<String>(value: "") // 검증에 따른 메시지
        
        let jobLength: PublishSubject<Int> = PublishSubject<Int>()
        let isCheckButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
        let success: PublishSubject<Bool> = PublishSubject<Bool>()
        let errorMessage: PublishSubject<String?> = PublishSubject<String?>()
        
        
    }
    
    // MARK: - Init
    init(myInfoSettingService: MyInfoSettingService) {
        self.myInfoSettingService = myInfoSettingService
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    func bind(input: Input) -> Output {
        
        
        let output = Output()
        
        getMyInformation(output: output)
        
        /// 닉네임필드 관찰후 유효문자,길이 판정
        observeNickNameTextChanged(input.nickNameTextChanged.asObservable(), output: output)
        
        // 텍스트 변경 관찰 및 유효성 검사
        observeJobTextChanges(input.jobTextChanged.asObservable(), output: output)
        
        bindingSaveButtonTapped(input: input, output: output)
        
        ///초기 완료버튼 가능하게
        output.isCheckButtonEnabled.accept(true)
        
        
        return output
    }
    
    /// 초기값 확인
    private func fetchExistingUserInfo() {
        var existingUserInfo: UserInfoResult?
        
        myInfoSettingService.getMyInformation()
            .subscribe(onNext: { [weak self] info in
                existingUserInfo = UserInfoResult(
                    nickname: info.nickname,
                    fieldOfWork: info.fieldOfWork,
                    job: info.job,
                    experienceYear: info.experienceYear
                )
            }).disposed(by: disposeBag)
    }
    
    /// 저장 버튼 바인딩
    private func bindingSaveButtonTapped(input: Input, output: Output) {
        input.saveButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<Response<UserInfoResult>> in
                guard let self = self else { return Observable.empty() }
                
                // 입력된 값이 없을 경우 기존 Output 값 사용
                let nickname = !input.nickNameTextChanged.value.isEmpty ? input.nickNameTextChanged.value : output.nickNameRelay.value
                let job = !input.jobTextChanged.value.isEmpty ? input.jobTextChanged.value : output.jobRelay.value
                let fieldOfWork = input.fieldOfWorkSelected.value ?? output.fieldOfWorkRelay.value
                let experienceYear = input.experienceYearSelected.value ?? output.experienceYearRelay.value
                
                let userInfoRequest = UserInfoRequest(
                    nickname: nickname,
                    fieldOfWork: fieldOfWork,
                    job: job,
                    experienceYear: experienceYear
                )
                
                return self.myInfoSettingService.saveMyInformation(userInfo: userInfoRequest)
            }
        
            .subscribe(onNext: { response in
                if response.isSuccess ?? false {
                    output.success.onNext(true)
                    print("저장 성공")
                } else {
                    output.errorMessage.onNext(response.message ?? "Error")
                    print("저장 실패")
                }
            }, onError: { error in
                output.errorMessage.onNext(error.localizedDescription)
                print("오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    /// Input Nick Name
    private func inputNickName(nickName: String, output: Output) {
        output.nickNameRelay.accept(nickName)
    }
    
    /// Input Nick Name
    private func inputfieldOfWork(info: MyInfo, output: Output) {
        output.fieldOfWorkRelay.accept(info.fieldOfWork ?? "")
    }
    
    private func inputjob(info: MyInfo, output: Output) {
        output.jobRelay.accept(info.job ?? "")
    }
    
    private func inputexperienceYear(info: MyInfo, output: Output) {
        output.experienceYearRelay.accept(info.experienceYear ?? "")
    }
    
    private func getMyInformation(output: Output) {
        myInfoSettingService.getMyInformation()
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                
                /// 정보 삽입
                inputNickName(nickName: info.nickname ?? "", output: output)
                inputfieldOfWork(info: info, output: output)
                inputjob(info: info, output: output)
                inputexperienceYear(info: info, output: output)
                
                
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 1.글자수
    /// 2. 글자 유효
    /// 3. 내 기존 입력과 동일성
    private func observeNickNameTextChanged(_ nickNameTextChanged: Observable<String>, output: Output) {
        nickNameTextChanged
            .flatMapLatest { [weak self] nickname -> Observable<(Bool, String)> in
                guard let self = self else { return .just((false, "검증 오류")) }
                
                // 글자수 및 글자 포맷 검사
                let isValidLength = nickname.count >= 2 && nickname.count <= 10
                let isValidFormat = self.isValidNickName(nickname)
                // 현재 닉네임과 비교
                let currentNickname = output.nickNameRelay.value
                
                if nickname == currentNickname {
                    return .just((true, ""))
                }
                if !isValidLength || !isValidFormat {
                    return .just((false, "유효하지 않은 닉네임입니다."))
                }
                
                // 중복 검사 수행
                return self.myInfoSettingService.nicknameDuplicate(nickname: nickname)
                    .map { response in
                        (response.isSuccess ?? false, response.isSuccess ?? false ? "사용 가능한 닉네임입니다." : "이미 사용 중인 닉네임입니다.")
                    }
                    .catchAndReturn((false, "유효하지 않은 닉네임입니다."))
            }
            .do(onNext: { isValid, message in
                output.nicknameValidationResult.accept(isValid)
                output.nicknameValidationMessage.accept(message)
            })
            .withLatestFrom(nickNameTextChanged) { ($0.0, $0.1, $1.count) }
            .subscribe(onNext: { isValid, message, length in
                
                /// 글자수 변화를 Output에
                output.nickNameLength.onNext(length)
            })
            .disposed(by: disposeBag)
        
        output.nicknameValidationResult
            .map { $0 }
            .bind(to: output.isCheckButtonEnabled)
            .disposed(by: disposeBag)
    }
    
    /// 정규식을 사용해서 조건에 맞는지 확인
    private func isValidNickName(_ nickName: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9.,!_~]+$"
        return nickName.range(of: regex, options: .regularExpression) != nil
    }
    
    private func observeJobTextChanges(_ jobTextChanged: Observable<String>, output: Output) {
        jobTextChanged
            .map { $0.count }
            .do(onNext: { length in
                output.isCheckButtonEnabled.accept(length >= 2 && length <= 30)
            })
            .bind(to: output.jobLength)
            .disposed(by: disposeBag)
    }
}
