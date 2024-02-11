//
//  DeletedImagePopUpViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/11/24.
//

import Foundation
import RxCocoa
import RxSwift

final class DeletedImagePopUpViewModel {
    private let disposeBag = DisposeBag()
    private let service = OffUIViewService()
    
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
    func createOutput(input: Input, selectedImage: Image?) -> Output {
        let output = Output()
        
        bindClickDeleteButtonEvents(input: input, output: output, selectedImage: selectedImage)
        return output
    }
    
    /// Bindingn Click Delete Button Events
    /// - Parameters:
    ///   - selectedImage: 선택한 이미지
    private func bindClickDeleteButtonEvents(input: Input, output: Output, selectedImage: Image?) {
        input.clickDeleteButtonEvents?
            .bind { [weak self] in
                guard let self = self, let id = selectedImage?.feedImageId else { return }
                deleteImage(output: output, id: id)
            }
            .disposed(by: disposeBag)
    }
    
    /// Delete Image
    /// - Parameters:
    ///   - id: 선택한 이미지 Id
    private func deleteImage(output: Output, id: Int) {
        service.deleteImage(imageId: id)
            .subscribe(onNext: { [weak self] check in
                guard let self = self else { return }
                print(#function, check)
                if check {
                    output.successDeleteSubject.onNext(check)
                }
            }, onError: { error in
                output.successDeleteSubject.onNext(true)
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
