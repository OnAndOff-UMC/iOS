//
//  MyPageViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/15/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class MyPageViewModel {
    private let disposeBag = DisposeBag()
    private let service = MyPageService()
    
    struct Input {
        let bookMarkButtonEvents: ControlEvent<Void>
        let alertSettingButtonEvents: ControlEvent<Void>
        let faqButtonEvents: ControlEvent<Void>
        let myInfoButtonEvents: ControlEvent<Void>
        let noticeButtonEvents: ControlEvent<Void>
        let feedBackButton: ControlEvent<Void>
        let policyButton: ControlEvent<Void>
        let versionButton: ControlEvent<Void>
        let reportButton: ControlEvent<Void>
        let logOutButton: ControlEvent<Void>
        let getOutButton: ControlEvent<Void>
    }
    
    struct Output {
        var nickNameRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var subTitleRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        
    }
    
    /// Create Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        getMyInformation(output: output)
        return output
    }
    
    /// Input Nick Name
    private func inputNickName(nickName: String, output: Output) {
        output.nickNameRelay.accept("\(nickName)님")
    }
    
    /// Input Nick Name
    private func inputSubTitle(info: MyInfo, output: Output) {
        output.subTitleRelay.accept("\(info.fieldOfWork ?? "") | \(info.experienceYear ?? "")")
    }
    
    /// Get My Information
    private func getMyInformation(output: Output) {
        service.getMyInformation()
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                inputNickName(nickName: info.nickname ?? "", output: output)
                inputSubTitle(info: info, output: output)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
