//
//  ModalSelectProfileViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/05.
//

import RxCocoa
import RxSwift

final class ModalSelectProfileViewModel {
    
    private let disposeBag = DisposeBag()
    private let loginService = LoginService()
    
    /// Input
    struct Input {
        
        /// 뷰가 로드될 때 이벤트 처리
        let viewDidLoad: Observable<Void>        
    }
    
    /// Output
    struct Output {
        let options: Observable<[String]>
        let labelText: Observable<String>
    }
    
    /// bind
    /// - Parameter input: input
    /// - Returns: output
    /// 입력을 받아 처리하고 출력을 반환
    func bind(input: Input, dataType: ProfileDataType) -> Output {
        let options = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[String]> in
                guard let self = self else { return .empty() }
                switch dataType {
                case .fieldOfWork:
                    return self.loginService.fetchJobOptions().map { $0.result ?? [] }.catchAndReturn([])
                    
                case .experienceYear:
                    return self.loginService.fetchExperienceYearsOptions().map { $0.result ?? [] }.catchAndReturn([])
                }
            }
        let labelText = Observable.just(dataType == .fieldOfWork ? "업무 분야" : "연차")
        
        return Output(options: options, labelText: labelText)
    }
}
