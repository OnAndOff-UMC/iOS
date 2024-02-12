//
//  InquireMemoirsViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/12.
//

import UIKit
import RxSwift
import RxCocoa

/// 회고록 설정
final class InquireMemoirsViewController: UIViewController {
    
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
    
    /// 오늘 배운 점 텍스트 필드
    private lazy var learnedTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .left
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.layer.borderColor = UIColor.clear.cgColor
        field.textColor = .black
        
        return field
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
    
    /// 칭찬할 점 텍스트 필드
    private lazy var praisedTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .left
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.layer.borderColor = UIColor.clear.cgColor
        field.textColor = .black
        
        return field
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
    
    /// 개선할 점 텍스트 필드
    private lazy var improvementTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .left
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.layer.borderColor = UIColor.clear.cgColor
        field.textColor = .black
        
        return field
    }()
    /// 개선할 점 View
    private lazy var improvementView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "회고록글보기이미지")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var viewModel: InquireMemoirsViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: InquireMemoirsViewModel) {
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
        //  setupBindings()
    }
    
    /// 화면 설정 관련 함수
    private func setupView(){
        view.backgroundColor = .OnOffLightMain
    }
    
    /// addSubviews
    private func addSubviews(){
        setupNavigationBar()
        view.addSubview(scrollView)
        
        contentView.addSubview(emoticonView)
        emoticonView.addSubview(imageView)
        
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(learnedLabel)
        contentView.addSubview(learnedView)
        contentView.addSubview(learnedTextField)
        
        
        contentView.addSubview(praisedLabel)
        contentView.addSubview(praisedView)
        contentView.addSubview(praisedTextField)
        
        
        contentView.addSubview(improvementLabel)
        contentView.addSubview(improvementView)
        contentView.addSubview(improvementTextField)
        
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
        
        learnedTextField.snp.makeConstraints { make in
            make.edges.equalTo(learnedView.snp.edges).offset(10)
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
        
        praisedTextField.snp.makeConstraints { make in
            make.edges.equalTo(praisedView.snp.edges).offset(10)
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
        
        improvementTextField.snp.makeConstraints { make in
            make.edges.equalTo(improvementView.snp.edges).offset(10)
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let memoirId = Observable.just("someMemoirId")
        
        let input = InquireMemoirsViewModel.Input(
            bookMarkButtonTapped: bookmarkButton.rx.tap.asObservable(),
            menuButtonTapped: menuButton.rx.tap.asObservable(),
            memoirId: memoirId
        )
        
        let output = viewModel.bind(input: input)
        
        // 북마크 상태에 따라 아이콘 업데이트
        output.updateBookmarkStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isBookmarked in
                let bookmarkImageName = isBookmarked ? "bookmark.fill" : "bookmark"
                self?.bookmarkButton.image = UIImage(systemName: bookmarkImageName)
            })
            .disposed(by: disposeBag)
    }
    
    /// 네비게이션 바
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [menuButton, bookmarkButton]
    }
}

