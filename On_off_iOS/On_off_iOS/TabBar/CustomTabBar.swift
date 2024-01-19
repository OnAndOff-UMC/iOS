//
//  CustomTabBar.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum TabItem: Int, CaseIterable, Equatable {
    case home
    case chat
    case my

    var normalImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .chat:
            return UIImage(systemName: "message")
        case .my:
            return UIImage(systemName: "person.crop.circle")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")
        case .chat:
            return UIImage(systemName: "message.fill")
        case .my:
            return UIImage(systemName: "person.crop.circle.fill")
        }
    }
}

final class CustomTabBar: UIView {
    private let stackView = UIStackView()
    private var buttons = [UIButton]()

    let items = TabItem.allCases
    fileprivate var selectedIndex = 0 {
        didSet {
            buttons.enumerated().forEach { i, btn in
                btn.isSelected = i == selectedIndex
            }
        }
    }

    private let disposeBag = DisposeBag()
    fileprivate var tapSubject = PublishSubject<Int>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUp() {
        items.enumerated().forEach { i, item in
            let button = UIButton()
            button.setImage(item.normalImage, for: .normal)
            button.setImage(item.selectedImage, for: .selected)
            button.isSelected = i == 0
            button.rx.tap
                .map { _ in i }
                .bind(to: tapSubject)
                .disposed(by: disposeBag)

            buttons.append(button)
        }

        tapSubject.bind(to: rx.selectedIndex)
            .disposed(by: disposeBag)

        backgroundColor = .lightGray

        addSubview(stackView)
        buttons.forEach(stackView.addArrangedSubview(_:))

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: CustomTabBar {
    var tapButton: Observable<Int> {
        base.tapSubject
    }

    var changeIndex: Binder<Int> {
        Binder(base) { base, index in
            base.selectedIndex = index
        }
    }
}
