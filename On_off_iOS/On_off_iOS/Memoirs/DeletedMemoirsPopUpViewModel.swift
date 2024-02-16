//
//  DeletedMemoirsPopUpViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/14.
//

import Foundation
import RxCocoa
import RxSwift

/// DeletedMemoirsPopUpViewModel: 팝업창 뷰모델
final class DeletedMemoirsPopUpViewModel {
    private let disposeBag = DisposeBag()
    private let service = MemoirsService()
    
    /// Input
    struct Input {
        var clickDeleteButtonEvents: ControlEvent<Void>?
        var memoirId: Int
    }
    
    /// Output
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
        print(input.memoirId)
        input.clickDeleteButtonEvents?
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                
                return service.deleteMemoirs(memoirId: input.memoirId)
                    .map { response -> Bool in
                        return response.isSuccess
                    }
                    .catchAndReturn(false)
            }
            .bind(to: output.successDeleteSubject)
            .disposed(by: disposeBag)
    }
}
