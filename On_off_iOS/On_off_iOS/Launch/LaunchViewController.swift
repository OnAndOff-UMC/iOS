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
        
        setupBindings()
        setupAnim()
        setupPassTime()
    }
    
    
    /// Setup Lottie animation
    private func setupAnim() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// Setup animation 시간 완료 동작
    private func setupPassTime() {
        animationView.play { [weak self] finished in
            if finished {
                self?.setupBindings()
            }
        }
    }
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = LaunchViewModel.Input(animationCompleted: Observable.just(()))
        let output = viewModel.bind(input: input)
        
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
            switch navigation {
            case .main:
                self?.moveToMain()
            case .onBoarding:
                self?.moveToOnBoarding()
            case .login:
                self?.moveToLogin()
            }
        }
    }
    
    /// 로그인 성공:  Main화면으로 이동 ❎ 임시 북마크
    private func moveToMain() {
        let mainViewController = BookmarkViewController(viewModel: BookmarkViewModel())
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    /// 회원가입인 경우: 온보딩으로 이동
    private func moveToOnBoarding() {
        let onBoardingViewController = OnBoardingViewController(viewModel: OnBoardingViewModel(navigationController: UINavigationController()))
        navigationController?.pushViewController(onBoardingViewController, animated: true)
    }
    
    /// 토큰만료: 로그인으로 이동
    private func moveToLogin() {
        let loginViewController = LoginViewController(viewModel: LoginViewModel(navigationController: UINavigationController(), loginService: LoginService()))
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
