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
    
    /// 소개글
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 하루도 수고했어요\n회고로 이제 일에서 완전히 OFF 하세요"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    /// 시작하기 버튼
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    /// 시작하기 버튼 뷰
    private lazy var startButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private var viewModel: StartToWriteViewModel
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
        view.backgroundColor = .white
        addSubviews()
        setupBindings()
    }
    
    /// addSubviews
    private func addSubviews(){
        view.addSubview(stackView)
        // 길쭉한 동그라미 뷰 추가
        stackView.addArrangedSubview(longView)

        // 2 번째동그라미 부터 추가
        for i in 0..<circleViews.count {
            stackView.addArrangedSubview(circleViews[i])
        }
        

        view.addSubview(welcomeLabel)
        view.addSubview(startButtonView)
        startButtonView.addSubview(startButton)
        
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints(){
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

        
        startButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(startButtonView.snp.width).multipliedBy(0.15)
            make.leading.trailing.equalToSuperview().inset(17)
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
        let input = StartToWriteViewModel.Input(startButtonTapped: startButton.rx.tap.asObservable())
    
        let output = viewModel.bind(input: input)

    }
}
