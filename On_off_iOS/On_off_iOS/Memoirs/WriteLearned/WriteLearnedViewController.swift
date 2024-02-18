//
//  WriteLearnedViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import UIKit
import RxSwift
import RxCocoa

final class WriteLearnedViewController: UIViewController {
    
    /// customBackButton
    private let backButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: MemoirsText.getText(for: .backButton), style: .plain, target: nil, action: nil)
        button.tintColor = .black
        return button
    }()
    
    /// pageControl
    private lazy var pageControlImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.PageControl2.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 사용자 명
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = KeychainWrapper.loadItem(forKey: ProfileKeyChain.nickname.rawValue)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// welcomeLabel
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .dailyReflection)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 회고록 작성페이지 그림
    private lazy var textpageImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.TextpageImage1.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 회고글 TextField
    private let textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textView.backgroundColor = UIColor.clear
        textView.layer.borderWidth = 0
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return textView
    }()
    
    /// 글자 수
    private let checkLenghtLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/500)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    /// 다음 버튼
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음 >", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.tintColor = .white
        return button
    }()
    
    /// 다음 버튼 뷰
    private lazy var checkButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffMain
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private let viewModel: WriteLearnedViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: WriteLearnedViewModel) {
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
        settingView()
        addSubviews()
        setupBindings()
        settingCheckButtonView()
    }
    
    private func settingView(){
        view.applyGradient(colors: [UIColor.OnOffMain, UIColor(hex: "BAA6FF")])
    }
    
    /// 확인 버튼 속성 설정
    private func settingCheckButtonView(){
        let cornerRadius = UICalculator.calculate(for: .shortButtonCornerRadius, width: view.frame.width)
        checkButtonView.layer.cornerRadius = cornerRadius
        checkButtonView.layer.masksToBounds = true
    }

    /// addSubviews
    private func addSubviews() {
        
        view.addSubview(pageControlImage)
        
        view.addSubview(userNameLabel)
        view.addSubview(welcomeLabel)
        
        view.addSubview(textpageImage)
        view.addSubview(textView)
        view.addSubview(checkLenghtLabel)
        
        view.addSubview(checkButtonView)
        checkButtonView.addSubview(checkButton)
        
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints() {
        
        self.navigationItem.leftBarButtonItem = backButton

        pageControlImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.25)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(pageControlImage.snp.width).multipliedBy(0.1)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControlImage.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        textpageImage.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(textpageImage.snp.width)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.top.equalTo(textpageImage).offset(50)
            make.height.equalTo(30).priority(.low)
            make.horizontalEdges.equalTo(textpageImage).inset(30)
        }

        checkLenghtLabel.snp.makeConstraints { make in
            make.top.equalTo(textpageImage.snp.bottom).offset(10)
            make.trailing.equalTo(textpageImage.snp.trailing).offset(10)
        }
        
        checkButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(checkButtonView.snp.width).multipliedBy(0.5)
        }
        
        checkButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = WriteLearnedViewModel.Input(
            startButtonTapped: checkButton.rx.tap.asObservable(),
            textChanged: textView.rx.text.orEmpty.asObservable(),
            backButtonTapped: backButton.rx.tap.asObservable()
        )
        
        let output = viewModel.bind(input: input)
        
        /// 각 바인딩 메소드
        bindUIEvents(input, output)
    }
    
    private func bindUIEvents(_ input: WriteLearnedViewModel.Input, _ output: WriteLearnedViewModel.Output) {
        
        /// text 변화감지
        bindingTextLength(output)
        
        /// 시작하기 버튼 클릭
        bindingSaveResult(output)
        
        /// 뒤로가기 버튼 클릭
        bindingSaveResult(output)
    }
    
    private func bindingTextLength(_ output: WriteLearnedViewModel.Output) {
        output.textLength
               .map { "(\($0)/500)" }
               .bind(to: checkLenghtLabel.rx.text)
               .disposed(by: disposeBag)
    }
    
    private func bindingSaveResult(_ output: WriteLearnedViewModel.Output) {
        output.saveResult
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.navigateToImprovement()
                } else {
                    //실패임
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingMoveToBack(_ output: WriteLearnedViewModel.Output) {
        output.moveToBack
                .subscribe(onNext: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: false)
                })
                .disposed(by: disposeBag)
    }
    
    private func navigateToImprovement() {
        let writeImprovementViewModel = WriteImprovementViewModel()
        let writeImprovementViewController = WriteImprovementViewController(viewModel: writeImprovementViewModel)
        self.navigationController?.pushViewController(writeImprovementViewController, animated: false)
    }
    
    // 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.endEditing(true)
    }
}

extension WriteLearnedViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        let maxHeight = textpageImage.frame.height - 50
        let newHeight = min(estimatedSize.height, maxHeight)
        
        textView.snp.updateConstraints { make in
            make.height.equalTo(newHeight).priority(.low)
        }
        
        self.view.layoutIfNeeded()
    }
}
