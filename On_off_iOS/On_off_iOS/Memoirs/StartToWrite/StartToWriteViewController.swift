//
//  StartToWriteViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import UIKit
import RxSwift
import RxCocoa

/// 작성 시작 ViewController
final class StartToWriteViewController: UIViewController {
    
    /// customBackButton
    private let backButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: MemoirsText.getText(for: .backButton), style: .plain, target: nil, action: nil)
        button.tintColor = .black
        return button
    }()
    
    /// pageControl
    private lazy var pageControlImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.PageControl1.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// StartToWriteImage
    private lazy var startToWriteImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.MemoirsCompleteImage.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 소개글
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .encouragement)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    /// 시작하기 버튼
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.tintColor = .white
        
        return button
    }()
    
    /// 시작하기 버튼 뷰
    private lazy var startButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.OnOffMain
        return view
    }()
    
    private let viewModel: StartToWriteViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: StartToWriteViewModel) {
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
        setupStartButtonView()
    }
    
    private func settingView(){
        view.backgroundColor = .OnOffLightMain
    }
    
    /// 시작  버튼 속성 설정
    private func setupStartButtonView(){
        let cornerRadius = UICalculator.calculate(for: .longButtonCornerRadius, width: view.frame.width)
        startButtonView.layer.cornerRadius = cornerRadius
        startButtonView.layer.masksToBounds = true
    }
    
    /// addSubviews
    private func addSubviews(){
        
        view.addSubview(pageControlImage)
        view.addSubview(startToWriteImage)
        view.addSubview(welcomeLabel)
        view.addSubview(startButtonView)
        startButtonView.addSubview(startButton)
        
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
        
        startToWriteImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(startToWriteImage.snp.width).multipliedBy(0.6)
            make.center.equalToSuperview()
        }
        
        startButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(startButtonView.snp.width).multipliedBy(0.15)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(startButtonView.snp.top).offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = StartToWriteViewModel.Input(startButtonTapped: startButton.rx.tap.asObservable(),
                                                backButtonTapped: backButton.rx.tap.asObservable())
        let output = viewModel.bind(input: input)
        
        output.moveToNext
                .subscribe(onNext: { [weak self] _ in
                    self?.navigateToWriteLearned()

                })
                .disposed(by: disposeBag)
        
        output.moveToBack
                .subscribe(onNext: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: false)
                })
                .disposed(by: disposeBag)
    }
    
    private func navigateToWriteLearned() {
        let writeLearnedViewModel = WriteLearnedViewModel()
        let writeLearnedViewController = WriteLearnedViewController(viewModel: writeLearnedViewModel)
        self.navigationController?.pushViewController(writeLearnedViewController, animated: false)
    }
    

}
