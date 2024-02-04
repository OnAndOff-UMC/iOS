//
//  ModalEmoticonViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import RxCocoa
import RxSwift

final class ModalEmoticonViewModel {
    private let disposeBag = DisposeBag()
    private let memoirsService = MemoirsService()
    private let emoticonsSubject = PublishSubject<[Emoticon]>()
    
    struct Input {
        // Input없음.
    }
    
    struct Output {
        let emoticons: Observable<[Emoticon]>
    }
    
    func bind(input: Input) -> Output {
        fetchEmoticons()
        return Output(emoticons: emoticonsSubject.asObservable())
    }
    
    private func fetchEmoticons() {
        memoirsService.getEmoticon()
            .subscribe(onNext: { [weak self] response in
                self?.emoticonsSubject.onNext(response.result)
            }, onError: { error in
                print("Error fetching emoticons: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
}

