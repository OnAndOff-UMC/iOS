//
//  OffUIViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class OffUIViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let todayMemoirsButtonEvents: ControlEvent<Void>?
        let todayMemoirsIconImageButtonEvents: ControlEvent<Void>?
        let feedTitleButton: ControlEvent<Void>?
        let feedPlusIconImageButton: ControlEvent<Void>?
    }
    
    struct Output {
        var imageURLRelay: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    }
    
    /// Create Output
    /// - Parameter input: Input
    /// - Returns: Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindTodayMemoirsEvents(input: input, output: output)
        bindFeedEvents(input: input, output: output)
        
        return output
    }
    
    /// 오늘의 회고 제목 버튼 및 이미지 버튼
    private func bindTodayMemoirsEvents(input: Input, output: Output) {
        input.todayMemoirsButtonEvents?
            .bind {
                print("tap todayMemoirsButtonEvents")
            }
            .disposed(by: disposeBag)
        
        input.todayMemoirsIconImageButtonEvents?
            .bind {
                print("tap todayMemoirsIconImageButtonEvents")
            }
            .disposed(by: disposeBag)
    }
    
    /// 워라벨 피드 제목 버튼 및 이미지 버튼
    private func bindFeedEvents(input: Input, output: Output) {
        input.feedTitleButton?
            .bind {
                print("tap feedTitleButton")
            }
            .disposed(by: disposeBag)
        
        input.feedPlusIconImageButton?
            .bind {
                print("tap feedPlusIconImageButton")
            }
            .disposed(by: disposeBag)
    }
}
