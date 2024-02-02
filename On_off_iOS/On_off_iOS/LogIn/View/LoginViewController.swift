//
//  LoginViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices
import RxGesture

///로그인 화면
final class LoginViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "반가워요!\n우리 같이 시작해볼까요?"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    /// 카카오 로그인 이미지뷰 생성 및 설정
    private lazy var kakaoLoginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kakao_login") // 카카오 로그인 이미지 설정
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    /// 애플 로그인 이미지뷰 생성 및 설정
    private lazy var appleLoginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "apple_login") // 애플 로그인 이미지 설정
        imageView.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAppleLoginImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    /// 이용약관 라벨
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "이용약관 및 개인정보 처리방침"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    var output: LoginViewModel.Output?
    
    
    // MARK: - Init
    init(viewModel: LoginViewModel) {
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
        view.backgroundColor = .white
        addSubviews()
        setupBindings()
    }
    
    /// addSubviews
    private func addSubviews(){
        view.addSubview(welcomeLabel)
        view.addSubview(kakaoLoginImageView)
        view.addSubview(appleLoginImageView)
        view.addSubview(termsLabel)
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints(){
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.equalToSuperview().offset(50)
        }
        
        kakaoLoginImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(kakaoLoginImageView.snp.width).multipliedBy(0.18)
        }
        
        appleLoginImageView.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginImageView.snp.bottom).offset(20)
            make.width.height.equalTo(kakaoLoginImageView)
            make.centerX.equalToSuperview()
        }
        
        termsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(view.snp.width).multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
        
    }
    
    /// 애플 로그인 과정을 시작
        @objc
    private func onAppleLoginImageViewTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    private func setupBindings() {
        let input = LoginViewModel.Input(
            kakaoButtonTapped: kakaoLoginImageView.rx.tapGesture().when(.recognized).asObservable()
            //appleButtonTapped: appleLoginImageView.rx.tapGesture().when(.recognized).asObservable()
        )
        
        // ViewModel bind 호출하고 output 받기
        self.output = viewModel.bind(input: input)
        guard let output = output else { return }
        self.output?.checkSignInService.subscribe(onNext: { signInStatus in
            print("로그인 상태: \(String(describing: signInStatus))")
        }).disposed(by: disposeBag)
    }
    
}

// MARK: - extension :ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
        case let passwordCredential as ASPasswordCredential:

            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
