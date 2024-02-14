//
//  DeletedMemoirsPopUpViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/14.
//

import Foundation
import RxCocoa
import RxSwift

final class DeletedMemoirsPopUpViewModel {
    private let disposeBag = DisposeBag()
    private let service = MemoirsService()
    
    
    struct Input {
        var clickDeleteButtonEvents: ControlEvent<Void>?
    }
    
    struct Output {
        var successDeleteSubject: PublishSubject<Bool> = PublishSubject()
    }
    
    /// Create Output
    /// - Parameters:
    ///   - selectedImage: 선택한 Id
    /// - Returns: Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindClickDeleteButtonEvents(input: input, output: output)
        return output
    }
    
    /// Bindingn Click Delete Button Events
    /// - Parameters:
    private func bindClickDeleteButtonEvents(input: Input, output: Output) {
        let output = Output()
        input.clickDeleteButtonEvents?
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                
                return self.service.deleteMemoirs(memoirId: 22)
                    .map { response -> Bool in
                        return response.isSuccess
                    }
                    .catchAndReturn(false)
            }
            .bind(to: output.successDeleteSubject)
            .disposed(by: disposeBag)
    }
}
