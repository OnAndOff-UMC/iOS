//
//  LaunchViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import Lottie
import SnapKit
import RxSwift
import UIKit

/// LaunchViewController - Launch화면
final class LaunchViewController: UIViewController {
    
    /// animationView - lottie
    private lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "onBoarding")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        return view
    }()
    
    private var viewModel: LaunchViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // _ = KeychainWrapper.delete(key: LoginKeyChain.refreshToken.rawValue)
        
        setupAnim()
        finishAnimation()
    }
    
    /// Setup Lottie animation
    private func setupAnim() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// Setup animation 시간 완료 동작
    private func finishAnimation() {
        animationView.play { [weak self] finished in
            if finished {
                self?.navigateAfterAnimation()
            }
        }
    }
    
    /// 로티 애니메이션 종료후 동작
    private func navigateAfterAnimation() {
        let input = LaunchViewModel.Input(animationCompleted: Observable.just(()))
        let output = viewModel.bind(input: input)
        
        /// 네비게이션 상황별 이동 시그널
        bindNabigationSignal(output)
    }
    
    private func bindNabigationSignal(_ output: LaunchViewModel.Output){
        output.navigationSignal
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] navigation in
                self?.navigate(to: navigation)
            })
            .disposed(by: disposeBag)
    }
    
    /// 화면 전환 로직
    private func navigate(to navigation: LaunchNavigation) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let navigationController = self.navigationController else { return }
            
            let viewController: UIViewController
            switch navigation {
                /// 메인화면으로 : - 로그인 성공후 자동로그인
            case .main:
                viewController = TabBarController()
                
                /// 온보딩으로: - 회원가입으로
            case .onBoarding:
                let viewModel = OnBoardingViewModel()
                viewController = OnBoardingViewController(viewModel: viewModel)
                
                /// 로그인으로: - 로그인화면으로
            case .login:
                let viewModel = LoginViewModel(loginService: LoginService())
                viewController = LoginViewController(viewModel: viewModel)
            }
            
            navigationController.setViewControllers([viewController], animated: true)
        }
    }
}
