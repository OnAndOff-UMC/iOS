//
//  ClickWorkLifeBalanceFeedViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ClickWorkLifeBalanceFeedViewModel {
    private let disposeBag = DisposeBag()
    private let service = ClickWorkLifeBalanceFeedService()
    
    struct Input {
        let completeDelayButtonEvents: ControlEvent<Void>?
        let deleteButtonEvents: ControlEvent<Void>?
        let selectedFeed: Observable<Feed>?
    }
    
    struct Output {
        var selectedFeedRelay: BehaviorRelay<Feed?> = BehaviorRelay(value: nil)
        var successConnectRelay: PublishRelay<Bool> = PublishRelay()
        var nextDay: BehaviorRelay<String> = BehaviorRelay(value: "")
    }
    
    
    /// Create Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindSelectedFeedRelay(input: input, output: output)
        bindCompleteDelayButtonEvents(input: input, output: output)
        bindDeleteButtonEvents(input: input, output: output)
        return output
    }
    
    /// Bind Selected Feed Relay
    private func bindSelectedFeedRelay(input: Input, output: Output) {
        input.selectedFeed?
            .bind { [weak self] feed in
                guard let self = self else { return }
                output.selectedFeedRelay.accept(feed)
                output.nextDay.accept(calculateNextDay(date: feed.date ?? ""))
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Complete Delay Button Events
    private func bindCompleteDelayButtonEvents(input: Input, output: Output) {
        input.completeDelayButtonEvents?
            .bind { [weak self] in
                guard let self = self else { return }
                delayTomorrow(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Delete Button Events
    private func bindDeleteButtonEvents(input: Input, output: Output) {
        input.deleteButtonEvents?
            .bind { [weak self] in
                guard let self = self, let id = output.selectedFeedRelay.value?.feedId else { return }
                service.deleteFeed(feedId: id)
                    .subscribe(onNext: { check in
                        if check {
                            output.successConnectRelay.accept(check)
                        }
                    }, onError: { error in
                        print(#function, error)
                    })
                    .disposed(by: disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    /// 내일로 미루기
    private func delayTomorrow(output: Output) {
        guard let id = output.selectedFeedRelay.value?.feedId else { return }
        service.delayTomorrow(feedId: id)
            .subscribe(onNext: { check in
                if check {
                    output.successConnectRelay.accept(check)
                }
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// Format Date To String
    /// - Parameter date: Date
    /// - Returns: String Type Date
    private func calculateNextDay(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day,
                              value: 1,
                              to: dateFormatter.date(from: date) ?? Date()) ?? Date())
    }
}
