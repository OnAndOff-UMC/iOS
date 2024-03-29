//
//  WritePraisedViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import UIKit
import RxSwift
import RxCocoa

/// WritePraisedViewController
final class WritePraisedViewController: UIViewController {
    
    /// customBackButton
    private let backButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: MemoirsText.getText(for: .backButton), style: .plain, target: nil, action: nil)
        button.tintColor = .black
        return button
    }()
    
    /// pageControl
    private lazy var pageControlImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.PageControl4.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 가장 윗줄 label
    private let welcomeUpperLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .difficultyPrompt)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// welcomeLabel
    private let welcomeBottomLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .improvementPrompt)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 회고록 작성페이지 그림
    private lazy var textpageImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.TextpageImage3.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 회고글 TextField
    private let textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
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
    
    /// 확인 버튼
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음 >", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.tintColor = .white
        return button
    }()
    
    /// 확인 버튼 뷰
    private lazy var checkButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffMain
        return view
    }()
    
    private let viewModel: WritePraisedViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: WritePraisedViewModel) {
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
        settingCheckButtonView()
        setupBindings()        
    }
    
    private func settingView(){
        view.backgroundColor = .OnOffLightMain
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
        view.addSubview(welcomeUpperLabel)
        view.addSubview(welcomeBottomLabel)
        
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
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(pageControlImage.snp.width).multipliedBy(0.1)
        }
        
        welcomeUpperLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControlImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        welcomeBottomLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeUpperLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        textpageImage.snp.makeConstraints { make in
            make.top.equalTo(welcomeBottomLabel.snp.bottom).offset(10)
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
        let input = WritePraisedViewModel.Input(startButtonTapped: checkButton.rx.tap.asObservable(),
                                                textChanged: textView.rx.text.orEmpty.asObservable(), backButtonTapped: backButton.rx.tap.asObservable())
        
        let output = viewModel.bind(input: input)
        
        
        /// 다음화면으로 이동
        bingdingMoveToNext(output)
        
        /// 뒤로 가기
        bingdingMoveToBack(output)
        
        /// 글자수 출력 바인딩
        bindingTextLength(output)
    }
    
    private func bindingTextLength(_ output: WritePraisedViewModel.Output) {
        output.textLength
            .map { "(\($0)/500)" }
            .bind(to: checkLenghtLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bingdingMoveToNext(_ output: WritePraisedViewModel.Output) {
        output.moveToNext
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.navigateToExpressdIcon()
                } else {
                    //실패임
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bingdingMoveToBack(_ output: WritePraisedViewModel.Output) {
        output.moveToBack
            .subscribe(onNext: { [weak self] in
                self?.navigationController?
                .popViewController(animated: false)})
    }
    
    private func navigateToExpressdIcon() {
        let expressedIconViewModel = ExpressedIconViewModel()
        let expressedIconViewController =  ExpressedIconViewController(viewModel: expressedIconViewModel)
        self.navigationController?.pushViewController(expressedIconViewController, animated: false)
    }
    
    // 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.endEditing(true)
    }
}

extension WritePraisedViewController: UITextViewDelegate {
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

