//
//  ExpressedIconViewModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/28.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

/// ExpressedIconViewModel
final class ExpressedIconViewModel {
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    private let memoirsService = MemoirsService()
    
    /// Input
    struct Input {
        let startButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    /// Output
    struct Output {
        let textLength: PublishSubject<Int> = PublishSubject<Int>()
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// binding Input
    /// - Parameter
    ///   - input: Input 구조체
    /// - Returns: Output 구조체
    func bind(input: Input) -> Output {
        let output = Output()
        
        /// 완료버튼 클릭
        input.startButtonTapped
            .bind { [weak self] in
                self?.sendMemoirsData()
                
                self?.moveToImprovement()
            }
            .disposed(by: disposeBag)
        
        /// 뒤로가기 버튼 클릭
        input.backButtonTapped
            .bind { [weak self] in
                guard let self = self else { return }
                moveToBack()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func sendMemoirsData() {
        let answer1 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer1.rawValue) ?? ""
        let answer2 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer2.rawValue) ?? ""
        let answer3 = KeychainWrapper.loadItem(forKey: MemoirsKeyChain.MemoirsAnswer3.rawValue) ?? ""
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: today)
        
        let request = MemoirRequest(
            date: dateString,
            emoticonId: 1, // 이모티콘 ID -> 수정
            memoirAnswerList: [
                MemoirRequest.MemoirAnswer(questionId: 1, answer: answer1),
                MemoirRequest.MemoirAnswer(questionId: 2, answer: answer2),
                MemoirRequest.MemoirAnswer(questionId: 3, answer: answer3)
            ]
        )
        
        memoirsService.saveMemoirs(request: request)
            .subscribe(onNext: { response in
                print("회고록 저장 성공: \(response)")
                self.moveToImprovement()
                
            }, onError: { error in
                print("회고록 저장 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    /// Memoirs 초기 화면으로 이동
    private func moveToImprovement() {
        let memoirsCompleteViewModel = MemoirsCompleteViewModel(navigationController: navigationController)
        let vc = MemoirsCompleteViewController(viewModel: memoirsCompleteViewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
    /// 뒤로 이동
    private func moveToBack() {
        navigationController.popViewController(animated: false)
    }
}

