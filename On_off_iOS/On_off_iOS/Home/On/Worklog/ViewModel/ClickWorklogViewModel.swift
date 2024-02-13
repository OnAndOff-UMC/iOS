//
//  ClickWorklogViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ClickWorklogViewModel {
    private let disposeBag = DisposeBag()
    private let service = ClickWorklogService()
    
    struct Input {
        let completeDelayButtonEvents: ControlEvent<Void>?
        let deleteButtonEvents: ControlEvent<Void>?
        let selectedWorklog: Observable<Worklog>?
    }
    
    struct Output {
        var selectedWorkRelay: BehaviorRelay<Worklog?> = BehaviorRelay(value: nil)
        var successConnectRelay: PublishRelay<Bool> = PublishRelay()
        var nextDay: BehaviorRelay<String> = BehaviorRelay(value: "")
    }
    
    
    /// Create Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindSelectedWorkRelay(input: input, output: output)
        bindCompleteDelayButtonEvents(input: input, output: output)
        bindDeleteButtonEvents(input: input, output: output)
        return output
    }
    
    /// Bind Selected Work Relay
    private func bindSelectedWorkRelay(input: Input, output: Output) {
        input.selectedWorklog?
            .bind { [weak self] Worklog in
                guard let self = self else { return }
                output.selectedWorkRelay.accept(Worklog)
                output.nextDay.accept(calculateNextDay(date: Worklog.date ?? ""))
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
                guard let self = self, let id = output.selectedWorkRelay.value?.worklogId else { return }
                service.delete(feedId: worklogId)
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
        guard let id = output.selectedWorkRelay.value?.worklogId else { return }
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
