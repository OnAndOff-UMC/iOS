//
//  BookmarkViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/03.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// BookmarkViewModel
final class BookmarkViewModel {
    
    private let disposeBag = DisposeBag()
    
    /// Input
    struct Input {
        let cellTapped: Observable<String>
    }
    
    /// Output
    struct Output {
    }

    /// binding Input
    /// - Parameters:
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) {
        input.cellTapped
            .subscribe(onNext: { [weak self] title in
                print("선택된거 날짜 보여줄꺼임: \(title)")
            })
            .disposed(by: disposeBag)
    }
}
