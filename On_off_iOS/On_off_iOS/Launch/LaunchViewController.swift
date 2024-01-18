//
//  LaunchViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import Foundation
import UIKit
import Lottie
import SnapKit

/// LaunchViewController - Launch화면
final class LaunchViewController: UIViewController {
    
    /// animationView - lottie
    private lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "onBoarding")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        return view
    }()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAnim()
        setupPassTime()
    }
    
    /// mark: -로티 화면 세팅
    private func setupAnim(){
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 애니메이션 끝나는 시간
    private func setupPassTime(){
        animationView.play { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                moveToMain()
            }
        }
    }
    
    /// 화면 이동
    private func moveToMain() {
        if let navigationController = self.navigationController {
                   let onBoardingViewController = OnBoardingViewController(viewModel: OnBoardingViewModel(navigationController: navigationController))
                   navigationController.pushViewController(onBoardingViewController, animated: true)
               }
    }
}
