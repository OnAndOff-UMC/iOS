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
    
    /// Input
    struct Input {
        
        /// 뷰가 로드될 때 이벤트 처리
        let viewDidLoad: Observable<Void>
        
        /// 이미지 선택 이벤트를 처리
        let imageSelected: Observable<Emoticon>
    }
    
    /// Output
    struct Output {
        let emoticons: Observable<[Emoticon]>
    }
    
    /// bind
    /// - Parameter input: input
    /// - Returns: output
    /// 입력을 받아 처리하고 출력을 반환
    func bind(input: Input) -> Output {
        
        /// 뷰 로드 시
        let emoticons = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[Emoticon]> in
                guard let self = self else { return .empty() }
                return fetchEmoticons()
            }
        
        /// 이미지 선택 이벤트 처리
        input.imageSelected
            .subscribe(onNext: { emoticon in
                print("선택된 emoticon: \(emoticon.emoticonId), URL: \(emoticon.imageUrl)")
            })
            .disposed(by: disposeBag)
        
        return Output(emoticons: emoticons)
    }
    
    /// 서버에서 이모티콘 데이터 fetch
    private func fetchEmoticons() -> Observable<[Emoticon]> {
        return memoirsService.getEmoticon()
            .map { $0.result }
            .catchAndReturn([])
    }
}
