//
//  AddWriteViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class AddWriteViewModel {
    
    private let disposeBag = DisposeBag()
    var navigationController: UINavigationController
    
    struct Input {
        let backButton: Observable<Void>
        let saveButton: Observable<Void>
        let plusButton: Observable<Void>
        let textInput: ControlProperty<String?>
    }
    
    struct Output {
        let tableData: Driver<[String]>
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
//    func bind(input: Input) -> Output {
//
//        let userText = BehaviorRelay<String?>(value: nil)
//
//        input.textInput
//            .compactMap { $0 }
//            .bind(to: userText)
//            .disposed(by: disposeBag)
//
//        /// 뒤로가기 버튼 클릭
//        input.backButton
//            .bind { [weak self] in
//                guard let self = self else { return }
//                self.moveToBack()
//            }
//            .disposed(by: disposeBag)
//
//        // plusButton을 누를 때마다 userText의 값을 테이블 뷰로 전달합니다.
//        let tableData = input.plusButton
//            .withLatestFrom(userText.asObservable()) // 마지막으로 발생한 userText의 값을 가져옵니다.
//            .compactMap { $0 } // 옵셔널 바인딩하여 nil이 아닌 값만 걸러냅니다.
//            .scan([]) { (accumulator, newValue) in // 누적된 배열에 새로운 값을 추가하여 배열을 생성합니다.
//                var newAccumulator = accumulator
//                newAccumulator.append(newValue)
//                return newAccumulator
//            }
//            .startWith([]) // 초기값 설정
//            .map { $0.map { $0 as String? } } // 배열의 각 요소를 옵셔널 String으로 변환합니다.
//            .asDriver(onErrorJustReturn: []) // 에러 처리 및 드라이버로 변환
//
//        return Output(tableData: tableData)
//    }
    
    /// 뒤로 이동 - animate 제거
    private func moveToBack() {
        navigationController.popViewController(animated: true)
    }
    
    /// 다짐 생성
    private func createResolution() {
        //createResolution
        
        
    }
}
