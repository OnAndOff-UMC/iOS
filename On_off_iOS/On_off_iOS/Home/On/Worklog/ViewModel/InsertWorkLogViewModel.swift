//
//  InsertWorkLogViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class InsertWorkLogViewModel {
    private let disposeBag = DisposeBag()
    private let service = InsertWorkLogService()
    final private let maxLength = 30
    
    struct Input {
        let textFieldEvents: ControlProperty<String>?
        let doneButtonEvents: ControlEvent<Void>?
        let insertWorklog: Observable<Worklog>
    }
    
    struct Output {
        var textRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var textCountRelay: BehaviorRelay<Int> = BehaviorRelay(value: 0)
        var successAddWorklogRelay: PublishRelay<Bool> = PublishRelay()
        var insertRelay: BehaviorRelay<Worklog?> = BehaviorRelay(value: nil)
    }
    
    /// Create Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindTextFieldEvents(input: input, output: output)
        bindDoneButtonEvents(input: input, output: output)
        bindInsertWorklog(input: input, output: output)
        
        return output
    }
    
    /// Bind Insert log
    private func bindInsertWorklog(input: Input, output: Output) {
        input.insertWorklog
            .bind { [weak self] Worklog in
                guard let self = self else { return }
                checkTextLimitCount(text: Worklog.content ?? "", output: output)
                output.insertRelay.accept(Worklog)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Textfield Events
    private func bindTextFieldEvents(input: Input, output: Output) {
        input.textFieldEvents?
            .bind { [weak self] text in
                guard let self = self else { return }
                checkTextLimitCount(text: text, output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Done Button Events
    private func bindDoneButtonEvents(input: Input, output: Output) {
        input.doneButtonEvents?
            .bind { [weak self] in
                guard let self = self else { return }
                if let Worklog = output.insertRelay.value, let id = Worklog.worklogId {
                    insertWorklog(worklogId: id, output: output)
                    return
                }
                addWorklog(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// 글자 수 최대 판별
    private func checkTextLimitCount(text: String, output: Output) {
        if text.count <= maxLength {
            output.textRelay.accept(text)
            output.textCountRelay.accept(text.count)
            return
        }
        output.textRelay.accept(String(text.dropLast(text.count-maxLength)))
        output.textCountRelay.accept(maxLength)
    }
    
    /// Format Date To String
    /// - Parameter date: Date
    /// - Returns: String Type Date
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    /// Add Feed To Backend Server
    private func addWorklog(output: Output) {
        let Worklog: AddWorklog = AddWorklog(date: formatDate(date: Date()),
                                    content: output.textRelay.value)
        print(Worklog)
        service.addWorklog(worklog: Worklog)
            .subscribe(onNext: { check in
                if check {
                    output.successAddWorklogRelay.accept(check)
                }
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// Insert Worklog
    private func insertWorklog(worklogId: Int, output: Output) {
        service.insertlog(worklogid: worklogId,content: output.textRelay.value)
            .subscribe(onNext: { check in
                if check {
                    output.successAddWorklogRelay.accept(check)
                }
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
