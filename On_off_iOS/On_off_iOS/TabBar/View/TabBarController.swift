//
//  TabBarController.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/27/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TabBarController: UIViewController {
    
    fileprivate let tabBar = CustomTabBar()
    private var childVCs = [UIViewController]()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기 설정 메서드 호출
        setUp()
    }
    
    // MARK: - 초기 설정
    private func setUp() {
        // 탭 바 및 컨트롤러 설정 메서드 호출
        setUpTabBar()
        setUpTabBarControllers()
        // 바인딩 설정 메서드 호출
        setUpBind()
    }
    
    // MARK: - 탭 바 컨트롤러 설정
    private func setUpTabBarControllers() {
        setUpTabBar()

        // 각 탭 아이템에 대응하는 뷰 컨트롤러 생성 및 배열에 추가
        for item in tabBar.viewModel.items {
            let vc: UIViewController
            switch item {
            case .statistics:
                vc = StatisticsViewController()
            case .home:
                vc = HomeViewController()
            case .my:
                vc = StatisticsViewController()
            }

            // 뷰 컨트롤러를 먼저 탭 바에 추가
            addChild(vc)
            view.addSubview(vc.view)

            // 뷰 컨트롤러의 뷰가 유효한지 확인 후 추가
            if let shouldFrontView = vc.view {
                if let superview = shouldFrontView.superview {
                    shouldFrontView.snp.makeConstraints {
                        make in
                        make.top.leading.trailing.equalTo(superview)
                        make.bottom.equalTo(tabBar.snp.top)
                    }
                } else {
                    print("Error: ViewController's superview is nil!")
                }
                childVCs.append(vc)
            } else {
                print("Error: ViewController's view is nil!")
            }
        }
    }
    
    // MARK: - 탭 바 설정
    private func setUpTabBar() {
        print("Before adding tabBar: \(view.subviews)")
        // Ensure tabBar is not already added
        guard tabBar.superview == nil else {
            print("TabBar is already added to the view.")
            return
        }
        
        if let superview = view {
            superview.addSubview(tabBar)
            print("After adding tabBar: \(superview.subviews)")
            
            tabBar.snp.makeConstraints {
                $0.leading.bottom.trailing.equalToSuperview()
                $0.top.equalTo(superview.snp.bottom).offset(-100)
            }
        } else {
            print("Error: View is nil.")
        }
    }
    
    // MARK: - 바인딩 설정
    private func setUpBind() {
        // 탭 바 버튼 탭 이벤트와 뷰 컨트롤러 전환 바인딩
        tabBar.rx.tapButton
            .bind(to: tabBar.rx.changeIndex)
            .disposed(by: disposeBag)
    }
}

// CustomTabBar에 대한 Reactive 확장
extension Reactive where Base: CustomTabBar {
    // 탭 버튼 선택 이벤트를 방출하는 Observable
    var tapButton: Observable<Int> {
        base.viewModel.tapSubject
    }
    
    // 선택된 탭 인덱스를 바인딩하는 Binder
    var changeIndex: Binder<Int> {
        Binder(base) { base, index in
            base.viewModel.selectedIndex = index
        }
    }
}
