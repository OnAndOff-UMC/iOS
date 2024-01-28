//
//  ExpressedIconViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/28.
//

import UIKit
import RxSwift
import RxCocoa

/// ExpressedIconViewController
final class ExpressedIconViewController: UIViewController {
    
    /// customBackButton
    private let backButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "〈 뒤로가기", style: .plain, target: nil, action: nil)
        button.tintColor = .black
        return button
    }()
    
    /// pageControl
    private lazy var pageControlImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "PageControl5"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// welcomeLabel
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘을 표현할 수 있는 아이콘을 골라주세요\n오늘의 감정이나 인상적인 일을 떠올려보세요"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 회고록 작성페이지 그림
    private lazy var textpageImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TextpageImage4"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 회고글 View
    private lazy var textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    /// 확인 버튼
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.tintColor = .white
        return button
    }()
    
    /// 확인 버튼 뷰
    private lazy var saveButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let viewModel: ExpressedIconViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: ExpressedIconViewModel) {
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
        settingCheckButtonView()
    }
    
    /// 확인 버튼 속성 설정
    private func settingCheckButtonView(){
        saveButtonView.layer.cornerRadius = view.frame.width * 0.3 * 0.25
        saveButtonView.layer.masksToBounds = true
    }
    
    /// addSubviews
    private func addSubviews() {

        view.addSubview(pageControlImage)
        view.addSubview(welcomeLabel)
        
        view.addSubview(textpageImage)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(saveButtonView)
        saveButtonView.addSubview(saveButton)
            
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

            welcomeLabel.snp.makeConstraints { make in
                make.top.equalTo(pageControlImage.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
            
            textpageImage.snp.makeConstraints { make in
                make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview().inset(10)
                make.height.equalTo(textFieldView.snp.width).multipliedBy(0.8)
            }
            
            textFieldView.snp.makeConstraints { make in
                make.edges.equalTo(textpageImage)
            }
            
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
            }
            
            saveButtonView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(50)
                make.height.equalTo(saveButtonView.snp.width).multipliedBy(0.15)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            saveButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = ExpressedIconViewModel.Input(startButtonTapped: saveButton.rx.tap.asObservable(),
                                               backButtonTapped: backButton.rx.tap.asObservable())
        
        let _ = viewModel.bind(input: input)
        
    }
    
    // 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textField.endEditing(true)
    }
}
