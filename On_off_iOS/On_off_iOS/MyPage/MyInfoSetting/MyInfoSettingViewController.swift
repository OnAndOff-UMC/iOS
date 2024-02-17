//
//  MyInfoSettingViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/17.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

/// 닉네임 설정
final class MyInfoSettingViewController: UIViewController {
    
    /// 닉네임
    private lazy var nickName: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    ///닉네임 textField
    private let nickNameTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.backgroundColor = UIColor.clear
        field.layer.borderWidth = 0
        return field
    }()
    
    /// 닉네임 라인
    private lazy var nickNameLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .OnOffMain
        return lineView
    }()
    
    /// 닉네임 글자 수
    private let checkLenghtLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/10)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    /// 닉네임 조건 설명
    private let nickNameExplainLabel: UILabel = {
        let label = UILabel()
        label.text = " 한글, 영어, 숫자, 특수문자(. , ! _ ~)로만 구성할 수 있어요 "
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    /// 업무분야
    private lazy var fieldOfWork: UILabel = {
        let label = UILabel()
        label.text = "업무 분야"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 업무분야 - 텍스트 필드
    private lazy var fieldOfWorkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택해 주세요", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var fieldOfWorkDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 업무분야 - 밑줄
    private lazy var fieldOfWorkLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .OnOffMain
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
    
    /// 직업 - 텍스트 필드
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
    
    /// 직업 - 글자수
    private let checkLenghtJobLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/30)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    /// 직업 - 밑줄
    private lazy var jobLine : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .OnOffMain
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
    
    /// 연차 - 버튼
    private lazy var annualButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택해 주세요", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var annualDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    /// 연차 - 밑줄
    private lazy var annualLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .OnOffMain
        return lineView
    }()
    
    /// 완료 버튼 - 네비게이션 바
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
        return button
    }()
    
    private var viewModel: ProfileSettingViewModel
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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingView()
        addSubviews()
        setupBindings()
    }
    
    private func settingView(){
        view.backgroundColor = UIColor.white
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    // 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        nickNameTextField.endEditing(true)
        jobTextField.endEditing(true)
    }
    
    /// addSubviews
    private func addSubviews(){
        
        view.addSubview(nickName)
        view.addSubview(nickNameTextField)
        view.addSubview(nickNameLine)
        view.addSubview(checkLenghtLabel)
        
        view.addSubview(fieldOfWork)
        view.addSubview(fieldOfWorkButton)
        view.addSubview(fieldOfWorkDownImage)
        view.addSubview(fieldOfWorkLine)
        
        view.addSubview(job)
        view.addSubview(jobTextField)
        view.addSubview(checkLenghtJobLabel)
        view.addSubview(jobLine)
        
        view.addSubview(annual)
        view.addSubview(annualButton)
        view.addSubview(annualDownImage)
        view.addSubview(annualLine)
        
        view.addSubview(nickNameExplainLabel)
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints(){
        
        ///닉네임
        nickName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview().offset(10)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickName.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        nickNameLine.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
        
        checkLenghtLabel.snp.makeConstraints { make in
            make.trailing.equalTo(jobLine.snp.trailing)
            make.centerY.equalTo(nickNameTextField.snp.centerY)
        }
        
        nickNameExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLine.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        /// 분야
        fieldOfWork.snp.makeConstraints { make in
            make.top.equalTo(nickNameExplainLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(10)
        }
        
        fieldOfWorkButton.snp.makeConstraints { make in
            make.top.equalTo(fieldOfWork.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(fieldOfWorkButton.snp.width).multipliedBy(0.1)
        }
        
        fieldOfWorkDownImage.snp.makeConstraints { make in
            make.centerY.equalTo(fieldOfWorkButton.snp.centerY)
            make.height.width.equalTo(fieldOfWorkButton.snp.height).multipliedBy(0.8)
            make.trailing.equalToSuperview().inset(10)
        }
        
        fieldOfWorkLine.snp.makeConstraints { make in
            make.top.equalTo(fieldOfWorkButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
        
        /// 직업
        job.snp.makeConstraints { make in
            make.top.equalTo(fieldOfWorkLine.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(10)
        }
        
        jobTextField.snp.makeConstraints { make in
            make.top.equalTo(job.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        checkLenghtJobLabel.snp.makeConstraints { make in
            make.trailing.equalTo(jobLine.snp.trailing)
            make.centerY.equalTo(jobTextField.snp.centerY)
        }
        
        jobLine.snp.makeConstraints { make in
            make.top.equalTo(jobTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
        
        /// 연차
        annual.snp.makeConstraints { make in
            make.top.equalTo(jobLine.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(10)
        }
        annualButton.snp.makeConstraints { make in
            make.top.equalTo(annual.snp.bottom).offset(18)
            make.leading.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(annualButton.snp.width).multipliedBy(0.1)
            
        }
        annualDownImage.snp.makeConstraints { make in
            make.centerY.equalTo(annualButton.snp.centerY)
            make.height.width.equalTo(annualButton.snp.height).multipliedBy(0.8)
            make.trailing.equalToSuperview().inset(10)
        }
        
        annualLine.snp.makeConstraints { make in
            make.top.equalTo(annualButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(1)
            
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = ProfileSettingViewModel.Input(startButtonTapped: saveButton.rx.tap.asObservable(),
                                                  jobTextChanged: jobTextField.rx.text.orEmpty.asObservable())
        let output = viewModel.bind(input: input)
        
        /// 글자수 출력 바인딩
        output.jobLength
            .map { "(\($0)/30)" }
            .bind(to: checkLenghtJobLabel.rx.text)
            .disposed(by: disposeBag)
                        
        saveButton.rx.tap
            .bind { [weak self] in
                if let nickName = self?.nickNameTextField.text {
                    _ = KeychainWrapper.saveItem(value: nickName, forKey: ProfileKeyChain.nickname.rawValue)
                }
                if let job = self?.jobTextField.text {
                    _ = KeychainWrapper.saveItem(value: job, forKey: ProfileKeyChain.job.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        fieldOfWorkButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presentModalForProfileSetting(dataType: .fieldOfWork)
            })
            .disposed(by: disposeBag)
        
        annualButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presentModalForProfileSetting(dataType: .experienceYear)
            })
            .disposed(by: disposeBag)
    }
    
    /// 이모티콘 모달 띄우기
    private func presentModalForProfileSetting(dataType: ProfileDataType) {
        let viewModel = ModalSelectProfileViewModel()
        let modalSelectProfileViewController = ModalSelectProfileViewController(viewModel: viewModel, dataType: dataType)
        modalSelectProfileViewController.delegate = self
        
        if #available(iOS 15.0, *) {
            if let sheet = modalSelectProfileViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
        present(modalSelectProfileViewController, animated: true, completion: nil)
    }
    
    /// 프로필설정으로 이동
    private func moveToSelectTime() {
        let selectTimeViewModel = SelectTimeViewModel()
        let vc = SelectTimeViewController(viewModel: selectTimeViewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/// extension : ModalSelectProfileDelegate : 모달창으로 부터 데이터 받기
extension MyInfoSettingViewController: ModalSelectProfileDelegate {
    func optionSelected(data: String, dataType: ProfileDataType) {
        switch dataType {
        case .fieldOfWork:
            self.fieldOfWorkButton.setTitle(data, for: .normal)
            _ = KeychainWrapper.saveItem(value: data, forKey: ProfileKeyChain.fieldOfWork.rawValue)
        case .experienceYear:
            self.annualButton.setTitle(data, for: .normal)
            _ = KeychainWrapper.saveItem(value: data, forKey: ProfileKeyChain.experienceYear.rawValue)
            
        }
    }
}
