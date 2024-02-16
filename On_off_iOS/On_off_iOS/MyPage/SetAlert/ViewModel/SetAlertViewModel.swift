//
//  SetAlertViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/16/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class SetAlertViewModel {
    private let disposeBag = DisposeBag()
    private let service = SetAlertService()
    
    /// Input
    struct Input {
        let checkAlertButtonEvents: ControlEvent<Void>
        let checkButtonEvents: ControlEvent<Void>
        let mondayButtonEvents: ControlEvent<Void>
        let tuesdayButtonEvents: ControlEvent<Void>
        let wednesdayButtonEvents: ControlEvent<Void>
        let thursdayButtonEvents: ControlEvent<Void>
        let fridayButtonEvents: ControlEvent<Void>
        let saturdayButtonEvents: ControlEvent<Void>
        let sundayButtonEvents: ControlEvent<Void>
    }
    
    /// Output
    struct Output {
        var checkAlertButtonRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var selectedAlertTimeRelay: BehaviorRelay<String> = BehaviorRelay(value: "00:00")
        var weekInformationRelay: BehaviorRelay<Alert?> = BehaviorRelay(value: nil)
        var successConnectSubject: PublishSubject<Void> = PublishSubject()
    }

    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()

        bindCheckAlertButtonEvents(input: input, output: output)
        bindCheckEvents(input: input, output: output)
        getAlertStatus(output: output)
        bindDayButtons(input: input, output: output)
        return output
    }
    
    /// Binding Day Buttons
    private func bindDayButtons(input: Input, output: Output) {
        input.mondayButtonEvents.asObservable()
            .bind {
                var info = output.weekInformationRelay.value
                info?.monday = !(output.weekInformationRelay.value?.monday ?? false)
                output.weekInformationRelay.accept(info)
            }
            .disposed(by: disposeBag)
        
        input.tuesdayButtonEvents.asObservable()
            .bind {
                var info = output.weekInformationRelay.value
                info?.tuesday = !(output.weekInformationRelay.value?.tuesday ?? false)
                output.weekInformationRelay.accept(info)
            }
            .disposed(by: disposeBag)
        
        input.wednesdayButtonEvents.asObservable()
            .bind {
                var info = output.weekInformationRelay.value
                info?.wednesday = !(output.weekInformationRelay.value?.wednesday ?? false)
                output.weekInformationRelay.accept(info)
            }
            .disposed(by: disposeBag)
        
        input.thursdayButtonEvents.asObservable()
            .bind {
                var info = output.weekInformationRelay.value
                info?.thursday = !(output.weekInformationRelay.value?.thursday ?? false)
                output.weekInformationRelay.accept(info)
            }
            .disposed(by: disposeBag)
        
        input.fridayButtonEvents.asObservable()
            .bind {
                var info = output.weekInformationRelay.value
                info?.friday = !(output.weekInformationRelay.value?.friday ?? false)
                output.weekInformationRelay.accept(info)
            }
            .disposed(by: disposeBag)
        
        input.saturdayButtonEvents.asObservable()
            .bind {
                var info = output.weekInformationRelay.value
                info?.saturday = !(output.weekInformationRelay.value?.saturday ?? false)
                output.weekInformationRelay.accept(info)
            }
            .disposed(by: disposeBag)
        
        input.sundayButtonEvents.asObservable()
            .bind {
                var info = output.weekInformationRelay.value
                info?.sunday = !(output.weekInformationRelay.value?.sunday ?? false)
                output.weekInformationRelay.accept(info)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Check Events
    private func bindCheckEvents(input: Input, output: Output) {
        input.checkButtonEvents
            .bind { [weak self]  in
                guard let self = self else { return }
                sendAlertInfo(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Check Alert Button Events
    private func bindCheckAlertButtonEvents(input: Input, output: Output) {
        input.checkAlertButtonEvents
            .bind {
                output.checkAlertButtonRelay.accept(!output.checkAlertButtonRelay.value)
            }
            .disposed(by: disposeBag)
    }
    
    /// Get Alert Status
    private func getAlertStatus(output: Output) {
        service.getAlertStatus()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                output.selectedAlertTimeRelay.accept(splitPushNotificationTime(time: result.pushNotificationTime))
                output.checkAlertButtonRelay.accept(result.receivePushNotification ?? false)
                output.weekInformationRelay.accept(result)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 초 단위 없애기
    private func splitPushNotificationTime(time: String?) -> String {
        guard let splitTime = time?.split(separator: ":") else { return "00:00" }
        return "\(splitTime[0]):\(splitTime[1])"
    }
    
    /// Send Alert Info
    private func sendAlertInfo(output: Output) {
        service.sendAlertInfo(info: Alert(pushNotificationTime: output.selectedAlertTimeRelay.value,
                                          receivePushNotification: output.checkAlertButtonRelay.value,
                                          monday: output.weekInformationRelay.value?.monday,
                                          tuesday: output.weekInformationRelay.value?.tuesday,
                                          wednesday: output.weekInformationRelay.value?.wednesday,
                                          thursday: output.weekInformationRelay.value?.thursday,
                                          friday: output.weekInformationRelay.value?.friday,
                                          saturday: output.weekInformationRelay.value?.saturday,
                                          sunday: output.weekInformationRelay.value?.sunday))
        .subscribe(onNext: { check in
            if check {
                output.successConnectSubject.onNext(())
            }
        }, onError: { error in
            print(#function, error)
        })
        .disposed(by: disposeBag)
    }
}
