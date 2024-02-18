//
//  InsertWorkLifeBalanceFeedViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/12/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class InsertWorkLifeBalanceFeedViewModel {
    private let disposeBag = DisposeBag()
    private let service = InsertWorkLifeBalanceFeedService()
    final private let maxLength = 30
    
    struct Input {
        let textFieldEvents: ControlProperty<String>?
        let doneButtonEvents: ControlEvent<Void>?
        let insertFeed: Observable<Feed>
    }
    
    struct Output {
        var textRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var textCountRelay: BehaviorRelay<Int> = BehaviorRelay(value: 0)
        var successAddFeedRelay: PublishRelay<Bool> = PublishRelay()
        var insertRelay: BehaviorRelay<Feed?> = BehaviorRelay(value: nil)
    }
    
    /// Create Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindTextFieldEvents(input: input, output: output)
        bindDoneButtonEvents(input: input, output: output)
        bindInsertFeed(input: input, output: output)
        
        return output
    }
    
    /// Bind Insert Feed
    private func bindInsertFeed(input: Input, output: Output) {
        input.insertFeed
            .bind { [weak self] feed in
                guard let self = self else { return }
                checkTextLimitCount(text: feed.content ?? "", output: output)
                output.insertRelay.accept(feed)
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
                if let feed = output.insertRelay.value, let id = feed.feedId {
                    insertFeed(feedId: id, output: output)
                    return
                }
                addFeed(output: output)
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
    private func addFeed(output: Output) {
        let feed: AddFeed = AddFeed(date: output.insertRelay.value?.date ?? "",
                                    content: output.textRelay.value)
        print(feed)
        service.addFeed(feed: feed)
            .subscribe(onNext: { check in
                if check {
                    output.successAddFeedRelay.accept(check)
                }
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// Insert Feed
    private func insertFeed(feedId: Int, output: Output) {
        service.insertFeed(feedId: feedId,content: output.textRelay.value)
            .subscribe(onNext: { check in
                if check {
                    output.successAddFeedRelay.accept(check)
                }
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
