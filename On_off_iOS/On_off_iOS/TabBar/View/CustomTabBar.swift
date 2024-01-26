//
//  CustomTabBar.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/27/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomTabBar: UIView {
    
    fileprivate var buttons = [UIButton]()
    
    // ViewModel 인스턴스
    internal let viewModel = CustomTabBarViewModel()
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - 설정
    private func setUp() {
        // 버튼 생성 및 액션 바인딩
        createButtons()
        bindButtonActions()
        
        // 탭 선택 이벤트를 ViewModel에 바인딩
        viewModel.tapButton
            .bind(to: viewModel.rx)
            .disposed(by: viewModel.disposeBag)
        
        // UI 구성
        configureUI()
    }
    
    private func createButtons() {
        // 탭 바에 아이템들을 순회하면서 버튼 생성
        viewModel.items.enumerated().forEach { index, item in
            let button = UIButton()
            button.setImage(item.normalImage, for: .normal)
            button.setImage(item.selectedImage, for: .selected)
            button.isSelected = index == 0
            buttons.append(button)
        }
    }
    
    private func bindButtonActions() {
        // 버튼들의 탭 액션을 Subject로 바인딩
        buttons.enumerated().forEach { index, button in
            button.rx.tap
                .map { index }
                .bind(to: viewModel.tapSubject)
                .disposed(by: viewModel.disposeBag)
        }
    }
    
    // 스택 뷰를 lazy로 선언하여 클로저를 사용해 초기화
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    // UI 구성 메서드에서 변경된 stackView 접근 방법
    private func configureUI() {
        backgroundColor = .white
        
        // Add buttons to stack view
        stackView.addArrangedSubview(buttons[0])
        stackView.addArrangedSubview(buttons[1])
        stackView.addArrangedSubview(buttons[2])
        
        // Stack view layout constraints
        stackView.snp.makeConstraints { (make) in
            if let superview = self.superview {
                make.edges.equalTo(superview)
            } else {
                // Handle the case where superview is nil
                print("Error: Superview is nil!")
            }
        }
        
    }
    
    // MARK: - 비공개 메서드
    // MARK: - 비공개 메서드
    private func updateSelectedState() {
        // 선택된 탭의 상태를 업데이트
        buttons.enumerated().forEach { index, button in
            button.isSelected = index == viewModel.selectedIndex
        }
    }
}

// CustomTabBar에 대한 Reactive 확장
extension Reactive where Base: CustomTabBarViewModel {
    // 선택된 탭 인덱스를 바인딩하는 Binder
    var selectedIndex: Binder<Int> {
        Binder(base) { viewModel, index in
            viewModel.selectedIndex = index
        }
    }
}
