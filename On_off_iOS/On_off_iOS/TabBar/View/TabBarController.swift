//
//  TabBarController.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/27/24.
//

import Foundation
import UIKit
import SnapKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 탭 바 커스텀 설정 및 뷰 컨트롤러 설정 초기화
        configureTabBar()
        setupViewControllers()
    }

    private func setupViewControllers() {
        // 탭 바에 표시할 뷰 컨트롤러들 생성
        let statisticsVC = createViewController(for: .statistics)
        let homeVC = createViewController(for: .home)
        let myVC = createViewController(for: .my)

        // 뷰 컨트롤러 배열 설정
        viewControllers = [statisticsVC, homeVC, myVC]

        // 탭 바 높이 설정
        tabBar.frame.size.height = UIScreen.main.bounds.height * 0.5
    }

    private func createViewController(for tabItem: TabItem) -> UIViewController {
        var viewController: UIViewController

        switch tabItem {
        case .statistics:
            viewController = StatisticsViewController()
        case .home:
            viewController = HomeViewController()
        case .my:
            viewController = StatisticsViewController()
        }

        // 탭 바 아이템 설정
        viewController.tabBarItem = UITabBarItem(
            title: nil,
            image: tabItem.normalImage?.withRenderingMode(.alwaysOriginal),
            selectedImage: tabItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        )

        // 뷰 컨트롤러를 네비게이션 컨트롤러로 감싸서 반환
        return UINavigationController(rootViewController: viewController)
    }

    private func configureTabBar() {
        // 탭 바의 색 및 기타 속성 설정
        tabBar.tintColor = .label
        tabBar.layer.masksToBounds = true
        tabBar.backgroundColor = .white
    }
}
