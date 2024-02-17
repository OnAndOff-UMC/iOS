//
//  OnUIViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit
import SnapKit

final class OnUIViewModel {
    private let disposeBag = DisposeBag()
    private let service = OnUIViewService()
    
    struct Input {
        let loadWLFeed: Observable<Void>?
        let clickCheckMarkOfWLFeed: Observable<Worklog>?
        let selectedDate: Observable<String>?
        let successAddWorklog: Observable<Void>?
    }
    
    struct Output {
        var tableViewHeightConstraint: BehaviorRelay<Constraint?> = BehaviorRelay(value: nil)
        var workLogRelay: BehaviorRelay<[Worklog]> = BehaviorRelay(value: [])
        var successCheckWLRelay: PublishRelay<Bool> = PublishRelay()
        var selectedDate: BehaviorRelay<String> = BehaviorRelay(value: "")
    }
    
    /// Create Output
    /// - Parameter input: Input
    /// - Returns: Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindSelectedWLFeed(input: input, output: output)
        bindLoadWLFeed(input: input, output: output)
        bindSelectedDate(input: input, output: output)
        bindSuccessAddWorklog(input: input, output: output)
        
        
        return output
    }
        
    /// Binding Load W.L.
    private func bindLoadWLFeed(input: Input, output: Output) {
        input.loadWLFeed?
            .bind {  [weak self] in
                guard let self = self else { return }
                getWorkLogList(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Selected Date
    private func bindSelectedDate(input: Input, output: Output) {
        input.selectedDate?
            .bind(to: output.selectedDate)
            .disposed(by: disposeBag)
    }
    
    /// Binding Success Add Worklog
    private func bindSuccessAddWorklog(input: Input, output: Output) {
        input.successAddWorklog?
            .bind {  [weak self] in
                guard let self = self else { return }
                getWorkLogList(output: output)
            }
            .disposed(by: disposeBag)
    }

    /// Binding Selected W.L
    private func bindSelectedWLFeed(input: Input, output: Output) {
        input.clickCheckMarkOfWLFeed?
            .bind { [weak self] feed in
                guard let self = self, let id = feed.worklogId else { return }
                checkWL(worklogId: id, input: input, output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Format Date To String
    /// - Parameter date: Date
    /// - Returns: String Type Date
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    /// Get WorkLog List
    /// - Parameters:
    ///   - selectedDate: Selected Date
    private func getWorkLogList(output: Output) {
        service.getWLList(date: output.selectedDate.value)
            .subscribe(onNext: { list in
                output.workLogRelay.accept(list)
            }, onError: { error in
                // 업로드 실패
                print(#function, error)
            })
            .disposed(by: disposeBag)
     
    }
    
    /// 업무일지 체크 유무
    /// - Parameters:
    ///   - worklogId: Worklog Id
    ///   - output: Output
    private func checkWL(worklogId: Int, input: Input, output: Output) {
        service.checkWL(worklogid: worklogId)
            .subscribe(onNext: { [weak self] Worklog in
                guard let self = self else { return }
                if Worklog {
                    output.successCheckWLRelay.accept(Worklog)
                    getWorkLogList(output: output)
                }
            }, onError:  { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
