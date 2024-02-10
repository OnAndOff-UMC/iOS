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
    
    /// 닉네임 설명 라벨
    private let nickNameExplainLabel: UILabel = {
        let label = UILabel()
        label.text = " 업무 분야, 직업, 연차는 추후에 ‘마이 페이지’에서 수정할 수 있어요. "
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    /// 확인 버튼
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    /// 확인버튼 뷰
    private lazy var checkButtonView: UIView = {
        let view = UIView()
        return view
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
        setupCheckButtonView()
        
    }
    
    /// 시작  버튼 속성 설정
    private func setupCheckButtonView(){
        let cornerRadius = UICalculator.calculate(for: .longButtonCornerRadius, width: view.frame.width)
        checkButtonView.layer.cornerRadius = cornerRadius
        checkButtonView.layer.masksToBounds = true
    }
    // 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        jobTextField.endEditing(true)
    }
    
    /// addSubviews
    private func addSubviews(){
        
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
        view.addSubview(checkButtonView)
        checkButtonView.addSubview(checkButton)
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints(){
        
        fieldOfWork.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
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
        nickNameExplainLabel.snp.makeConstraints { make in
            make.bottom.equalTo(checkButton.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        checkButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(checkButtonView.snp.width).multipliedBy(0.15)
            make.leading.trailing.equalToSuperview().inset(17)
            
            checkButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = ProfileSettingViewModel.Input(startButtonTapped: checkButton.rx.tap.asObservable(),
                                                  jobTextChanged: jobTextField.rx.text.orEmpty.asObservable())
        let output = viewModel.bind(input: input)
        
        /// 글자수 출력 바인딩
        output.jobLength
            .map { "(\($0)/30)" }
            .bind(to: checkLenghtJobLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 버튼 활성화 상태 및 색상 변경 바인딩
        output.isCheckButtonEnabled
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isEnabled in
                guard let self = self else { return }
                checkButton.isEnabled = isEnabled
                checkButtonView.layer.borderColor = UIColor.OnOffMain.cgColor
                checkButtonView.layer.borderWidth = 1
                
                checkButtonView.backgroundColor = isEnabled ? UIColor.OnOffMain : .white
                checkButton.setTitleColor(isEnabled ? .white : UIColor.OnOffMain, for: .normal)
            }
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .bind { [weak self] in
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
}

/// extension : ModalSelectProfileDelegate : 모달창으로 부터 데이터 받기
extension ProfileSettingViewController: ModalSelectProfileDelegate {
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
