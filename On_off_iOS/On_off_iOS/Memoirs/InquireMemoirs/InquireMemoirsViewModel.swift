//
//  InquireMemoirsViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/12.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// MemoirsViewModel
final class InquireMemoirsViewModel {
    
    private let disposeBag = DisposeBag()
    private let memoirsService = MemoirsService()
    
    /// Input
    struct Input {
        let bookMarkButtonTapped: Observable<Void>
        let menuButtonTapped: Observable<Void>
        let memoirId: Observable<String> // 북마크를 업데이트할 회고록 ID
    }
    
    /// Output
    struct Output {
        let memoirResponse : BehaviorRelay<MemoirResponse?> // 회고록 조회 결과
        let updateBookmarkStatus : Observable<Bool> // 북마크 상태 업데이트
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
 
        
        /// 북마크 버튼 클릭
        input.bookMarkButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                print("북마크")
            }
            .disposed(by: disposeBag)
        
        /// 메뉴 버튼 클릭
        input.menuButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                print("메뉴 버튼 ")
            }
            .disposed(by: disposeBag)
        
    let memoirResponse = BehaviorRelay<MemoirResponse?>(value: nil)
        
        // 북마크 버튼 클릭 시 북마크 상태 업데이트
        let updateBookmarkStatus = input.bookMarkButtonTapped
            .withLatestFrom(input.memoirId) // 북마크 업데이트를 위해 필요한 회고록 ID 가져오기
            .flatMapLatest { [weak self] memoirId -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                return self.memoirsService.bookMarkMemoirs(memoirId: memoirId)
                    .map { response -> Bool in
                        return response.result.isBookmarked
                    }
                    .catchAndReturn(false)
            }
        
        return Output(
            memoirResponse: memoirResponse,
            updateBookmarkStatus: updateBookmarkStatus
        )
    }
}
