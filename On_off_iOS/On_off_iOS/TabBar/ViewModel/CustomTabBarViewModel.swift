//
//  CustomTabBarViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/27/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CustomTabBarViewModel {
    // ReactiveX의 rx 속성 및 disposeBag를 공개
    internal let rx = PublishRelay<Int>()
    let disposeBag = DisposeBag()
    
    // 탭 선택 이벤트를 방출할 Subject
    // private에서 internal로 변경
    internal var tapSubject = PublishSubject<Int>()
    
    // 탭 선택 이벤트를 Observable로 노출
    var tapButton: Observable<Int> {
        return tapSubject
    }
    
    // 선택된 탭의 인덱스를 관리하는 변수
    var selectedIndex = 0 {
        didSet {
            // 선택된 탭의 상태를 업데이트
            tapSubject.onNext(selectedIndex)
        }
    }
    
    // 탭 바에 표시할 아이템들
    let items = TabItem.allCases
    
    init() {
        // ViewModel의 추가적인 초기화 로직이 필요하다면 이곳에 작성
    }
}
