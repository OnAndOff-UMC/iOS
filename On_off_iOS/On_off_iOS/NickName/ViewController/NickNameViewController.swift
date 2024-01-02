//
//  NickNameViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import UIKit
import RxSwift
import RxCocoa

/// 닉네임 설정
final class NickNameViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "일의 성장과\n삶의 밸런스를 위한\n준비를 시작해볼까요?"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        field.backgroundColor = UIColor.clear
        field.layer.borderWidth = 0
        return field
    }()
    private lazy var nickNameLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .black
        return lineView
    }()
    
    private let nickNameExplainLabel: UILabel = {
        let label = UILabel()
        label.text = " 한글, 영어, 숫자, 특수문자(. , ! _ ~)로만 구성할 수 있어요 "
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    var viewModel: NickNameViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: NickNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        bind()
    }
    /// addSubviews
    private func addSubviews(){
        view.addSubview(welcomeLabel)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(nickNameLine)
        
        view.addSubview(nickNameExplainLabel)
        view.addSubview(checkButton)
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints(){
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(50)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(50)
        }
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        nickNameLine.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }

        nickNameExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLine.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
   
        checkButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        nickNameTextField.endEditing(true)
    }
    
    private func bind() {
      
        
        let input = NickNameViewModel.Input(startButtonTapped: checkButton.rx.tap.asObservable())
        
        viewModel.bind(input: input)
    }

}
