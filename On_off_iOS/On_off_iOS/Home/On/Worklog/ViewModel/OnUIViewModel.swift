//
//  OnUIViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
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
        let collectionViewCellEvents: ControlEvent<IndexPath>?
        let loadWLFeed: Observable<Void>?
        let clickCheckMarkOfWLFeed: Observable<Worklog>?
        let selectedDate: Observable<String>?
        let successAddWorklog: Observable<Void>?
    }
    
    struct Output {
        var collectionViewHeightConstraint: BehaviorRelay<Constraint?> = BehaviorRelay(value: nil)
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
    
    /// Binding Load W.L.B Feed
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
    
    /// Binding Success Add Feed
    private func bindSuccessAddWorklog(input: Input, output: Output) {
        input.successAddWorklog?
            .bind {  [weak self] in
                guard let self = self else { return }
                getWorkLogList(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Selected W.L.B Feed
    private func bindSelectedWLFeed(input: Input, output: Output) {
        input.clickCheckMarkOfWLFeed?
            .bind { [weak self] feed in
                guard let self = self, let id = feed.worklogId else { return }
                checkWLFeed(feedId: id, input: input, output: output)
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
    ///   - worklogId: Feed Id
    ///   - output: Output
    private func checkWL(worklogId: Int, input: Input, output: Output) {
        service.checkWL(worklogId: worklogId)
            .subscribe(onNext: { [weak self] check in
                guard let self = self else { return }
                if check {
                    output.successCheckWLRelay.accept(check)
                    getWorkLogList(output: output)
                }
            }, onError:  { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
