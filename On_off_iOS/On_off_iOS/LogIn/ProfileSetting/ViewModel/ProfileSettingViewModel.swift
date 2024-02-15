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
        
        // 닉네임 텍스트 변경 관찰 및 유효성 검사
        input.jobTextChanged
            .map { nickName in
                return nickName.count // 닉네임 길이만 반환
            }
            .do(onNext: { length in
                output.isCheckButtonEnabled.accept(length >= 2 && length <= 30) // 2자 이상 30자 이하 조건만 검사
            })
            .bind(to: output.jobLength)
            .disposed(by: disposeBag)
        
        // 시작 버튼 탭 이벤트 처리
        input.startButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<Response<TokenResult>> in
                guard let self = self else {
                    return .empty()
                }
                return self.loginWithSelectedData()
            }
            .subscribe(onNext: { response in
                if response.isSuccess {
                    output.success.onNext(true)
                } else {
                    output.errorMessage.onNext(response.message)
                }
            }, onError: { error in
                output.errorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
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
            let givenName = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.giveName.rawValue) ?? ""
            let familyName = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.familyName.rawValue) ?? ""
            let email = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.email.rawValue) ?? ""
            let identityTokenString = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.identityTokenString.rawValue) ?? ""
            let authorizationCodeString = KeychainWrapper.loadItem(forKey: AppleLoginKeyChain.authorizationCodeString.rawValue) ?? ""
            
            let fullName = FullName(giveName: givenName, familyName: familyName)
            
            let additionalInfo = AdditionalInfo(nickname: nickname, fieldOfWork: fieldOfWork, job: job, experienceYear: experienceYear)
            let request = AppleTokenValidationRequest(
                oauthId: oauthId,
                fullName: fullName,
                email: email,
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
