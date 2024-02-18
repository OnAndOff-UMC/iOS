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

/// ProfileSettingViewModel
final class ProfileSettingViewModel {
    private let disposeBag = DisposeBag()
    private let loginService: LoginService
    
    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let jobTextChanged: Observable<String>
    }
    
    /// Output
    struct Output {
        let jobLength: PublishSubject<Int> = PublishSubject<Int>()
        let isCheckButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)
        let success: PublishSubject<Bool> = PublishSubject<Bool>()
        let errorMessage: PublishSubject<String?> = PublishSubject<String?>()
    }
    
    // MARK: - Init
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        
        // 텍스트 변경 관찰 및 유효성 검사
        observeJobTextChanges(input.jobTextChanged, output: output)
        
        // 시작 버튼 탭 이벤트 처리
        handleStartButtonTapped(input.startButtonTapped, output: output)
        
        return output
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
    
    private func handleStartButtonTapped(_ startButtonTapped: Observable<Void>, output: Output) {
        startButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<Response<TokenResult>> in
                guard let self = self else { return .empty() }
                return self.loginWithSelectedData()
            }
            .subscribe(onNext: { response in
                if response.isSuccess ?? false {
                    output.success.onNext(true)
                } else {
                    output.errorMessage.onNext(response.message)
                }
            }, onError: { error in
                output.errorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    /// loginWithSelectedData 로그인 종류별 로그인
    private func loginWithSelectedData() -> Observable<Response<TokenResult>> {
        
        guard let loginMethod = KeychainWrapper.loadItem(forKey: LoginMethod.loginMethod.rawValue),
              let nickname = KeychainWrapper.loadItem(forKey: ProfileKeyChain.nickname.rawValue),
              let fieldOfWork = KeychainWrapper.loadItem(forKey: ProfileKeyChain.fieldOfWork.rawValue),
              let job = KeychainWrapper.loadItem(forKey: ProfileKeyChain.job.rawValue),
              let experienceYear = KeychainWrapper.loadItem(forKey: ProfileKeyChain.experienceYear.rawValue)
        else {
            return .empty()
        }
        
        /// apple은 최초 이후엔 정보 optional로 nil 값
        if loginMethod == "apple" {
            let oauthId = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.oauthId.rawValue) ?? ""
            let identityTokenString = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.identityTokenString.rawValue) ?? ""
            let authorizationCodeString = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.authorizationCodeString.rawValue) ?? ""
            
            let additionalInfo = AdditionalInfo(nickname: nickname, fieldOfWork: fieldOfWork, job: job, experienceYear: experienceYear)
            let request = AppleTokenValidationRequest(
                oauthId: oauthId,
                
                identityToken: identityTokenString,
                authorizationCode: authorizationCodeString,
                additionalInfo: additionalInfo
            )
            
            return loginService.validateAppleTokenAndSendInfo(request: request)
        }
        
        else if loginMethod == "kakao" {
            guard let identityToken = KeychainWrapper.loadItem(forKey: KakaoLoginKeyChain.idToken.rawValue),
                  let accessToken = KeychainWrapper.loadItem(forKey: KakaoLoginKeyChain.accessToken.rawValue)
            else {
                return .empty()
            }
            
            let additionalInfo = AdditionalInfo(nickname: nickname, fieldOfWork: fieldOfWork, job: job, experienceYear: experienceYear)
            let request = KakaoTokenValidationRequest(identityToken: identityToken, accessToken: accessToken, additionalInfo: additionalInfo)
            return loginService.validateKakaoTokenAndSendInfo(request: request)
        }
        return .empty()
    }
}
