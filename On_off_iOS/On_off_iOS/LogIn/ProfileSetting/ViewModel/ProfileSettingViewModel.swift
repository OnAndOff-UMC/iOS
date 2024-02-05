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
    private var navigationController: UINavigationController
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
    init(navigationController: UINavigationController, loginService: LoginService) {
        self.navigationController = navigationController
        self.loginService = loginService
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        
        // 닉네임 텍스트 변경 관찰 및 유효성 검사
        input.jobTextChanged
            .map { [weak self] nickName in
                return (nickName.count, self?.isValidNickName(nickName) ?? false)
            }
            .do(onNext: { (length, isValid) in
                output.isCheckButtonEnabled.accept(length >= 2 && length <= 30 && isValid)
            })
            .map { $0.0 } // 길이만 반환
            .bind(to: output.jobLength)
            .disposed(by: disposeBag)
        
        // 시작 버튼 탭 이벤트 처리
        input.startButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<KakaoTokenValidationResponse> in
                guard let self = self else {
                    return .empty()
                }
                return self.loginWithSelectedData()
            }
            .subscribe(onNext: { response in
                if response.isSuccess {
                    output.success.onNext(true)
                    self.moveToSelectTime()
                } else {
                    output.errorMessage.onNext(response.message)
                }
            }, onError: { error in
                output.errorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func loginWithSelectedData() -> Observable<KakaoTokenValidationResponse> {
        
        guard let identityToken = KeychainWrapper.loadItem(forKey: KakaoLoginKeyChain.idToken.rawValue),
              let accessToken = KeychainWrapper.loadItem(forKey: KakaoLoginKeyChain.accessToken.rawValue),
              let fieldOfWork = KeychainWrapper.loadItem(forKey: ProfileKeyChain.fieldOfWork.rawValue),
              let job = KeychainWrapper.loadItem(forKey: ProfileKeyChain.job.rawValue),
              let experienceYear = KeychainWrapper.loadItem(forKey: ProfileKeyChain.experienceYear.rawValue)
        else {
            return .empty()
        }
        
        let additionalInfo = AdditionalInfo(fieldOfWork: fieldOfWork, job: job, experienceYear: experienceYear)
        let request = KakaoTokenValidationRequest(identityToken: identityToken, accessToken: accessToken, additionalInfo: additionalInfo)
        print(request)
        return loginService.validateKakaoTokenAndSendInfo(request: request)
    }
    
    /// 정규식을 사용해서 조건에 맞는지 확인
    private func isValidNickName(_ nickName: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9.,!_~]+$"
        return nickName.range(of: regex, options: .regularExpression) != nil
    }
    
    /// 프로필설정으로 이동
    private func moveToSelectTime() {
        let selectTimeViewModel = SelectTimeViewModel(navigationController: navigationController)
        let vc = SelectTimeViewController(viewModel: selectTimeViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}


