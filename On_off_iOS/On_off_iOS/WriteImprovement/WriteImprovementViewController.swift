//
//  WriteImprovementViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import UIKit
import RxSwift
import RxCocoa

final class WriteImprovementViewController: UIViewController {
    
    /// 상위 동그라미 스택뷰
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    /// dot
    private let circleViews = (1...4).map { _ -> UIView in
         let view = UIView()
         view.backgroundColor = .red
         return view
     }
    /// 현재 dot
    private let longView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    /// 사용자 명
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "어려웠다거나 아쉬운 것도 있나요?"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    /// welcomeLabel
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "다음엔 더 잘할 수 있을거예요"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    /// 회고글 View
    private lazy var textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    /// 회고글 TextField
    private let textField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "배운점을 입력하세요",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.backgroundColor = UIColor.clear
        field.layer.borderWidth = 0
        return field
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
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    /// 확인 버튼 뷰
    private lazy var checkButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private var viewModel: WriteImprovementViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: WriteImprovementViewModel) {
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
    private func addSubviews() {
        view.addSubview(stackView)
        
        // 첫 번째와 두 번째 동그라미 뷰 추가
        for i in 0..<2 {
            stackView.addArrangedSubview(circleViews[i])
        }

        // 길쭉한 동그라미 뷰 추가
        stackView.addArrangedSubview(longView)

        // 세 번째와 네 번째 동그라미 뷰 추가
        for i in 2..<circleViews.count {
            stackView.addArrangedSubview(circleViews[i])
        }
        
        view.addSubview(userNameLabel)
        view.addSubview(welcomeLabel)

        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(checkLenghtLabel)
            
        view.addSubview(checkButtonView)
        checkButtonView.addSubview(checkButton)
            
        configureConstraints()
    }
        
        /// configureConstraints
        private func configureConstraints() {
            // 가로 길이가 2배인 뷰의 제약 조건
            longView.snp.makeConstraints { make in
                    make.width.equalTo(100)
                    make.height.equalTo(50)
                }
                
            // 동그라미 뷰들의 제약 조건
            circleViews.forEach { circleView in
                circleView.snp.makeConstraints { make in
                    make.width.height.equalTo(50)
                }
                circleView.layer.cornerRadius = 25 // 반지름 25로 설정하여 동그라미 형태 만듦
            }
            
            // 스택 뷰의 제약 조건
            stackView.snp.makeConstraints { make in
                make.height.equalTo(view.snp.width).multipliedBy(0.2)
                make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
                make.centerX.equalToSuperview()
            }

            userNameLabel.snp.makeConstraints { make in
                make.top.equalTo(stackView.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(10)
            }

            welcomeLabel.snp.makeConstraints { make in
                make.top.equalTo(userNameLabel.snp.bottom).offset(10)
                make.leading.equalToSuperview().offset(10)
            }
            
            textFieldView.snp.makeConstraints { make in
                make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview().inset(10)
                make.height.equalTo(textFieldView.snp.width).multipliedBy(1.12)
            }
            
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
            }
            
            checkLenghtLabel.snp.makeConstraints { make in
                make.top.equalTo(textFieldView.snp.bottom).offset(10)
                make.trailing.equalTo(textFieldView)
            }
            
            checkButtonView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(50)
                make.leading.trailing.equalToSuperview().inset(17)
                make.height.equalTo(checkButtonView.snp.width).multipliedBy(0.15)
            }
            
            checkButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    
    /// 뒤로가기
    private func backButton() {
        navigationController?.popViewController(animated: false)
    }
        /// 뷰모델과 setupBindings
        private func setupBindings() {
            let input = WriteImprovementViewModel.Input(startButtonTapped: checkButton.rx.tap.asObservable(),
                                                textChanged: textField.rx.text.orEmpty.asObservable())
            
            let output = viewModel.bind(input: input)
            
        /// 글자수 출력 바인딩
        output.textLength
            .map { "(\($0)/500)" }
            .bind(to: checkLenghtLabel.rx.text)
            .disposed(by: disposeBag)
        }
        
        // 키보드내리기
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            textField.endEditing(true)
        }
    }
