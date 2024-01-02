//
//  ProfileSettingViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import UIKit
import RxSwift
import RxCocoa

/// 닉네임 설정
final class ProfileSettingViewController: UIViewController {
    
    /// 업무분야
    private lazy var fieldOfWork: UILabel = {
        let label = UILabel()
        label.text = "업무 분야"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 업무분야
    private lazy var fieldOfWorkTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "예시) 커머스, 여행, 소셜, AI, 제조업 등",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        field.backgroundColor = UIColor.clear
        field.layer.borderWidth = 0
        return field
    }()
    private lazy var fieldOfWorkLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .black
        return lineView
    }()
    /// 직업
    private lazy var job: UILabel = {
        let label = UILabel()
        label.text = "직업"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 직업
    private lazy var jobTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "예시) 서비스 기획자, UX 디자이너, 개발자 등",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.textAlignment = .left
        field.backgroundColor = UIColor.clear
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.layer.borderColor = UIColor.clear.cgColor
        field.textColor = .black
        
        return field
    }()
    private lazy var jobLine : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .black
        return lineView
    }()
    /// 연차
    private lazy var annual: UILabel = {
        let label = UILabel()
        label.text = "연차"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 연차
    private lazy var annualTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "예시) 인턴, 신입, 1년, 5년 이상, 시니어 등 ",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.textAlignment = .left
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.layer.borderWidth = 0
        return field
    }()
    private lazy var annualLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .black
        return lineView
    }()
    
    /// 설명
    private lazy var descriptions: UILabel = {
        let label = UILabel()
        label.text = "∙ 특수문자, 띄어쓰기를를 입력할 수 없습니다.\n∙ 최소 2글자, 최대 8글자 입력가능합니다."
        label.numberOfLines = 2
        label.textColor = .black
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    /// 완료 버튼
    private lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("완료", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        return btn
    }()
    

    private let nickNameExplainLabel: UILabel = {
        let label = UILabel()
        label.text = " 업무 분야, 직업, 연차는 추후에 ‘마이 페이지’에서 수정할 수 있어요. "
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
    var viewModel: ProfileSettingViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: ProfileSettingViewModel) {
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
        //bind()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        fieldOfWorkTextField.endEditing(true)
        jobTextField.endEditing(true)
        annualTextField.endEditing(true)
        
    }
    /// addSubviews
    private func addSubviews(){
        
        view.addSubview(fieldOfWork)
        view.addSubview(fieldOfWorkTextField)
        view.addSubview(fieldOfWorkLine)

        
        view.addSubview(job)
        view.addSubview(jobTextField)
        view.addSubview(jobLine)

        view.addSubview(annual)
        view.addSubview(annualTextField)
        view.addSubview(annualLine)

        view.addSubview(nickNameExplainLabel)
        view.addSubview(checkButton)
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints(){
                
        fieldOfWork.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        fieldOfWorkTextField.snp.makeConstraints { make in
            make.top.equalTo(fieldOfWork.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        fieldOfWorkLine.snp.makeConstraints { make in
            make.top.equalTo(fieldOfWorkTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        
        /// 직업
        job.snp.makeConstraints { make in
            make.top.equalTo(fieldOfWorkLine.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        jobTextField.snp.makeConstraints { make in
            make.top.equalTo(job.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        jobLine.snp.makeConstraints { make in
            make.top.equalTo(jobTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)
        }
        
        /// 연차
        annual.snp.makeConstraints { make in
            make.top.equalTo(jobLine.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        annualTextField.snp.makeConstraints { make in
            make.top.equalTo(annual.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        annualLine.snp.makeConstraints { make in
            make.top.equalTo(annualTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1)

        }
        nickNameExplainLabel.snp.makeConstraints { make in
            make.bottom.equalTo(checkButton.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        checkButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
    }
  
}
