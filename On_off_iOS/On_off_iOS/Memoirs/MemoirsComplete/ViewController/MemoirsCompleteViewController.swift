//
//  MemoirsCompleteViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/29.
//

import UIKit
import RxSwift
import RxCocoa

/// MemoirsCompleteViewController
final class MemoirsCompleteViewController: UIViewController {
    
    /// customBackButton
    private let backButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: MemoirsText.getText(for: .backButton), style: .plain, target: nil, action: nil)
        button.tintColor = .black
        return button
    }()
    
    /// welcomeLabel
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .memorialCompleted)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    /// 회고록 작성페이지 그림
    private lazy var MemoirsCompleteImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.MemoirsCompleteImage.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 확인 버튼
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오늘의 회고 완료", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.tintColor = .white
        return button
    }()
    
    /// 확인 버튼 뷰
    private lazy var saveButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffMain
        return view
    }()
    
    private let viewModel: MemoirsCompleteViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: MemoirsCompleteViewModel) {
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
        setupUI()
        addSubviews()
        setupBindings()
        settingCheckButtonView()
    }
    
    private func setupUI() {
        view.applyGradient(colors: [UIColor.OnOffMain, UIColor(hex: "BAA6FF")])
    }
    
    /// 확인 버튼 속성 설정
    private func settingCheckButtonView() {
        let cornerRadius = UICalculator.calculate(for: .longButtonCornerRadius, width: view.frame.width)
        saveButtonView.layer.cornerRadius = cornerRadius
        saveButtonView.layer.masksToBounds = true
    }
    
    /// addSubviews
    private func addSubviews() {
        
        view.addSubview(MemoirsCompleteImage)
        view.addSubview(welcomeLabel)
          
        view.addSubview(saveButtonView)
        saveButtonView.addSubview(saveButton)
        
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints() {
        
        self.navigationItem.leftBarButtonItem = backButton
        MemoirsCompleteImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(MemoirsCompleteImage.snp.width).multipliedBy(0.6)
            make.center.equalToSuperview()
        }

        saveButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(saveButtonView.snp.width).multipliedBy(0.15)
            make.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(saveButtonView.snp.top).offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = MemoirsCompleteViewModel.Input(completedButtonTapped: saveButton.rx.tap.asObservable(),
                                                 backButtonTapped: backButton.rx.tap.asObservable())
        
        let output = viewModel.bind(input: input)
        moveToNext(output)
    }
    
    private func moveToNext(_ output: MemoirsCompleteViewModel.Output) {
        output.moveToNext
            .subscribe(onNext: { [weak self] in
                self?.navigateToTabbar()
            })
    }
    
    private func navigateToTabbar() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

