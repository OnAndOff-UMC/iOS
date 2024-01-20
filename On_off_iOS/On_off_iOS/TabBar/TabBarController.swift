//
//  TabBarController.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomTabBarController: UIViewController {
    fileprivate let tabBar = CustomTabBar()
    private var childVCs = [UIViewController]()
    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUp() {
        setUpTabBar()
        setUpTabBarControllers()
        setUpBind()
    }

    private func setUpTabBar() {
        view.addSubview(tabBar)
        tabBar.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(-100)
        }
    }

    private func setUpTabBarControllers() {
        for item in tabBar.items {
            let vc: UIViewController
            switch item {
            case .statistics:
                vc = StatisticsViewController()
            case .home:
                vc = StatisticsViewController()
            case .my:
                vc = StatisticsViewController()
            }

            addChild(vc)
            view.addSubview(vc.view)
            vc.didMove(toParent: self)

            vc.view.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(tabBar.snp.top)
            }

            childVCs.append(vc)
        }

        guard let shouldFrontView = childVCs.first?.view else { return }
        view.bringSubviewToFront(shouldFrontView)
    }


    
    private func setUpBind() {
        tabBar.rx.tapButton
            .bind { [weak self] index in
                guard let self = self else { return }
                guard let shouldFrontView = self.childVCs[index].view else { return }
                self.view.bringSubviewToFront(shouldFrontView)
            }
            .disposed(by: disposeBag)
    }

    private func addLabel(in vc: UIViewController, text: String?) {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.text = text
        vc.view.addSubview(label)

        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension Reactive where Base: CustomTabBarController {
    var changeIndex: Binder<Int> {
        Binder(base) { base, index in
            base.tabBar.rx.changeIndex.onNext(index)
        }
    }
}
