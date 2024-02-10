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
        let feedTitleButtonEvents: ControlEvent<Void>?
        let feedPlusIconImageButtonEvents: ControlEvent<Void>?
        let collectionViewCellEvents: ControlEvent<IndexPath>?
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
        bindClickedCollectoinViewCell(input: input, output: output)
        
        dummy(output: output)
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
        input.feedTitleButtonEvents?
            .bind {
                print("tap feedTitleButton")
            }
            .disposed(by: disposeBag)
        
        input.feedPlusIconImageButtonEvents?
            .bind {
                print("tap feedPlusIconImageButton")
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Clicked CollectionView Cell
    private func bindClickedCollectoinViewCell(input: Input, output: Output) {
        input.collectionViewCellEvents?
            .bind { indexPath in
                print(indexPath, output.imageURLRelay.value[indexPath.row])
            }
            .disposed(by: disposeBag)
    }
    
    /// dummy Data
    private func dummy(output: Output) {
        let list = ["a","a1","a2","a3","a4","a5","a6","a7","a8","plus.circle.fill"]
        output.imageURLRelay.accept(list)
    }
}
