//
//  MemoirsViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/20.
//

import UIKit
import RxSwift
import RxCocoa

/// 회고록 설정
final class MemoirsViewController: UIViewController {
    
    /// 북마크 버튼 - 네비게이션 바
    private lazy var bookmarkButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: MemoirsImage.bookmark.rawValue), style: .plain, target: nil, action: nil)
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                print("북마크 로직 구현")
            })
            .disposed(by: disposeBag)
        return button
    }()
    
    /// 메뉴 버튼 - 네비게이션 바
    private lazy var menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: MemoirsImage.ellipsis.rawValue)?.rotated(by: .pi / 2), style: .plain, target: nil, action: nil)
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                print("메뉴 로직 구현")
            })
            .disposed(by: disposeBag)
        return button
    }()
    
    /// 전체 스크롤 뷰
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    /// scrollView 내부 contentView
    private lazy var contentView: UIView = {
        let view = UIView()
        // 세 개의 뷰를 여기에 추가
        return view
    }()
    
    /// systemImage +버튼
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .OnOffMain
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    /// emoticon View
    private lazy var emoticonView: UIView = {
        let label = UILabel()
        return label
    }()
    
    /// emoticon 이미지
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// date label
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜 정보"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// 오늘 배운 점 label
    private lazy var learnedLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .learnedToday)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// 오늘 배운 점 View
    private lazy var learnedView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "회고록글보기이미지")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 칭찬할 점 label
    private lazy var praisedLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .praiseToday)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// 칭찬할 점 View
        private lazy var praisedView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "회고록글보기이미지")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
    
    /// 개선할 점 label
    private lazy var improvementLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .improveFuture)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// 개선할 점 View
        private lazy var improvementView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "회고록글보기이미지")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
    
    private var viewModel: MemoirsViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: MemoirsViewModel) {
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
        setupView()
        addSubviews()
        setupBindings()
    }
    
    /// 화면 설정 관련 함수
    private func setupView(){
        view.backgroundColor = .OnOffLightMain
    }
    
    /// addSubviews
    private func addSubviews(){
        setupNavigationBar()
        view.addSubview(scrollView)
        view.addSubview(writeButton)
        
        contentView.addSubview(emoticonView)
        emoticonView.addSubview(imageView)
        
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(learnedLabel)
        contentView.addSubview(learnedView)
        
        contentView.addSubview(praisedLabel)
        contentView.addSubview(praisedView)
        
        contentView.addSubview(improvementLabel)
        contentView.addSubview(improvementView)
        
        configureConstraints()
    }
    
    /// configureConstraints
    private func configureConstraints(){
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        writeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.trailing.equalTo(view.snp.trailing).inset(50)
            make.width.height.equalTo(50)
        }
        
        emoticonView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(emoticonView.snp.width).multipliedBy(0.4)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(emoticonView.snp.height).multipliedBy(0.8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(emoticonView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        learnedLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        learnedView.snp.makeConstraints { make in
            make.top.equalTo(learnedLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(learnedView.snp.width).multipliedBy(0.4)
        }
        
        praisedLabel.snp.makeConstraints { make in
            make.top.equalTo(learnedView.snp.bottom).offset(18)
            make.leading.equalToSuperview().inset(15)
        }
        
        praisedView.snp.makeConstraints { make in
            make.top.equalTo(praisedLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(praisedView.snp.width).multipliedBy(0.4)
        }
        
        improvementLabel.snp.makeConstraints { make in
            make.top.equalTo(praisedView.snp.bottom).offset(18)
            make.leading.equalToSuperview().inset(15)
        }
        
        improvementView.snp.makeConstraints { make in
            make.top.equalTo(improvementLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(improvementView.snp.width).multipliedBy(0.4)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = MemoirsViewModel.Input(bookMarkButtonTapped: bookmarkButton.rx.tap.asObservable(),
                                           menuButtonTapped: menuButton.rx.tap.asObservable(),
                                           writeButtonTapped: writeButton.rx.tap.asObservable())
        
        let output = viewModel.bind(input: input)
        
        output.shouldNavigateToStartToWrite
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToStartToWrite()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToStartToWrite() {
        let startToWriteViewModel = StartToWriteViewModel()
        let startToWriteViewController = StartToWriteViewController(viewModel: startToWriteViewModel)
        self.navigationController?.pushViewController(startToWriteViewController, animated: false)
    }
    
    /// 네비게이션 바
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [menuButton, bookmarkButton]
    }
}
