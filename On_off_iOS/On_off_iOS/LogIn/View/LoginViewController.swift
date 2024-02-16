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

/// 로그인 화면
final class LoginViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "반가워요!\n우리 같이 시작해볼까요?"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    /// 이미지뷰 생성 및 설정
    private lazy var decorateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "온보딩시작")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
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
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    private let appleLoginSuccessSubject = PublishSubject<Void>()
    
    
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
        settingUI()
        addSubviews()
        setupBindings()
    }
    
    /// settingUI
    private func settingUI(){
        view.backgroundColor = UIColor.OnOffMain
    }
    
    /// addSubviews
    private func addSubviews(){
        view.addSubview(welcomeLabel)
        view.addSubview(decorateImageView)
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
        decorateImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(view.snp.width).multipliedBy(0.8)
        }
        kakaoLoginImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(decorateImageView.snp.bottom).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(kakaoLoginImageView.snp.width).multipliedBy(0.18)
        }
        
        appleLoginImageView.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginImageView.snp.bottom).offset(20)
            make.width.height.equalTo(kakaoLoginImageView)
            make.centerX.equalToSuperview()
        }
        
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(appleLoginImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    /// 애플 로그인 과정을 시작
    @objc
    private func onAppleLoginImageViewTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// setupBindings : viewMode과l bind
    private func setupBindings() {
        
        let input = LoginViewModel.Input(
            kakaoButtonTapped: kakaoLoginImageView.rx.tapGesture().when(.recognized).asObservable(),
            appleLoginSuccess: appleLoginSuccessSubject.asObservable() // 애플 로그인 성공 이벤트를 Observable로 전달
            
        )
        
        let output = viewModel.bind(input: input)
        
        output.checkSignInService.subscribe(onNext: { signInStatus in
            print("로그인 상태: \(String(describing: signInStatus))")
        })
        .disposed(by: disposeBag)
        
        /// 닉네임설정 뷰 바인딩
        bindingMoveToNickName(output)
        
        /// 뒤로 이동 바인딩
        bindingMoveToBack(output)
        
        /// 메인화면으로 바인딩
        bindingMoveToMain(output)
        
    }
    private func bindingMoveToNickName(_ output: LoginViewModel.Output) {
        output.moveToNickName
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.moveToNickName()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingMoveToMain(_ output: LoginViewModel.Output) {
        output.moveToMain
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.moveToMain()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingMoveToBack(_ output: LoginViewModel.Output) {
        output.moveToBack
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    
    /// 닉네임 설정으로 이동
    private func moveToNickName() {
        print("이동해야함")
        let nickNameViewModel = NickNameViewModel()
        let nickNameViewController =  NickNameViewController(viewModel: nickNameViewModel)
        self.navigationController?.pushViewController(nickNameViewController, animated: true)
    }
    
    /// 메인 화면으로 이동
    private func moveToMain() {
        print("이동해야함")
        let nickNameViewModel = NickNameViewModel()
        let nickNameViewController =  NickNameViewController(viewModel: nickNameViewModel)
        self.navigationController?.pushViewController(nickNameViewController, animated: true)
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
            
            ///identityToken, authorizationCode를 인코딩
            guard let identityToken = appleIDCredential.identityToken,
                  let authorizationCode = appleIDCredential.authorizationCode,
                  let identityTokenString = String(data: identityToken, encoding: .utf8),
                  let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else {
                print("Error")
                return
            }
            print("""
                  {
                  "oauthId": \(userIdentifier),
                  "identityToken": \(identityTokenString),
                  "authorizationCode": \(authorizationCodeString),
                  "additionalInfo": {
                    "fieldOfWork": "부동산_임대업",
                    "job": "aa",
                    "experienceYear": "신입"
                  }
                  }
                  """)
            // 키체인에 정보 저장
            _ = KeychainWrapper.saveItem(value: "apple", forKey: LoginMethod.loginMethod.rawValue)
            _ = KeychainWrapper.saveItem(value: userIdentifier, forKey: AppleLoginKeyChain.oauthId.rawValue)
            _ = KeychainWrapper.saveItem(value: identityTokenString, forKey: AppleLoginKeyChain.identityTokenString.rawValue)
            _ = KeychainWrapper.saveItem(value: authorizationCodeString, forKey: AppleLoginKeyChain.authorizationCodeString.rawValue)
            appleLoginSuccessSubject.onNext(())
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
