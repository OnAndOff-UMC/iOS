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
final class InquireMemoirsViewController: UIViewController, UITextFieldDelegate {
    
    /// 북마크 버튼 - 네비게이션 바
    private lazy var bookmarkButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: MemoirsImage.bookmark.rawValue),
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        
        return button
    }()
    
    /// 메뉴 버튼 - 네비게이션 바
    private lazy var menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: MemoirsImage.ellipsis.rawValue)?.rotated(by: .pi / 2),
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        
        return button
    }()
    
    /// 완료 버튼 - 네비게이션 바
    private lazy var reviceButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
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
    
    /// emoticon Button
    private lazy var emoticonButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isEnabled = false
        return button
    }()
    
    /// emoticon 이미지
    private lazy var emoticonImage: UIImageView = {
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
        field.isEnabled = false
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
        field.isEnabled = false
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
        field.isEnabled = false
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
    
    /// 오늘날짜 받아옴
    var todayDateSubject: PublishSubject<String> = PublishSubject()
    
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
        setupBindings()
        
        /// 탭 제스처 리코그나이저를 뷰에 추가 (  키보드 숨기기 이슈 )
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    /// 화면 설정 관련 함수
    private func setupView(){
        view.backgroundColor = .OnOffLightMain
        // 텍스트 필드 delegate 설정
        learnedTextField.delegate = self
        praisedTextField.delegate = self
        improvementTextField.delegate = self
        
        emoticonView.isUserInteractionEnabled = true
        emoticonImage.isUserInteractionEnabled = true
        emoticonButton.isUserInteractionEnabled = true
        
    }
    
    /// addSubviews
    private func addSubviews(){
        setupNavigationBar()
        view.addSubview(scrollView)
        
        contentView.addSubview(emoticonView)
        emoticonView.addSubview(emoticonImage)
        emoticonView.addSubview(emoticonButton)
        
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
        
        emoticonImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(emoticonView.snp.height).multipliedBy(0.8)
        }
        
        emoticonButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(emoticonImage)
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
            make.top.equalTo(learnedView).offset(20)
            make.height.equalTo(30).priority(.low)
            make.horizontalEdges.equalTo(learnedView).inset(30)
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
            make.top.equalTo(praisedView).offset(20)
            make.height.equalTo(30).priority(.low)
            make.horizontalEdges.equalTo(praisedView).inset(30)
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
            make.top.equalTo(improvementView).offset(20)
            make.height.equalTo(30).priority(.low)
            make.horizontalEdges.equalTo(improvementView).inset(30)
        }
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        
        let learnedTextObservable: Observable<String?> = learnedTextField.rx.text.asObservable()
        let praisedTextObservable: Observable<String?> = praisedTextField.rx.text.asObservable()
        let improvementTextObservable: Observable<String?> = improvementTextField.rx.text.asObservable()
        
        let input = InquireMemoirsViewModel.Input(
            bookMarkButtonTapped: bookmarkButton.rx.tap.asObservable(),
            menuButtonTapped: menuButton.rx.tap.asObservable(),
            reviseButtonTapped: reviceButton.rx.tap.asObservable(),
            memoirInquiry: Observable.just(()),
            toggleEditing: PublishSubject<Void>().asObservable(),
            learnedText: learnedTextObservable,
            praisedText: praisedTextObservable,
            improvementText: improvementTextObservable,
            selectedDateEvents: todayDateSubject
        )
        
        emoticonButton.rx.tap
            .bind { [weak self] in
                self?.presentModalEmoticonViewController()
            }
            .disposed(by: disposeBag)
        
        let output = viewModel.bind(input: input)
        
        reviceButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.toggleEditingMode(isEditing: false)
            }).disposed(by: disposeBag)
        
        output.memoirInquiryResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self, let response = response else { return }
                updateUIWithMemoirResponse(response)
            })
            .disposed(by: disposeBag)
        
        output.updateBookmarkStatus
            .subscribe(onNext: { [weak self] isBookmarked in
                let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
                self?.bookmarkButton.image = UIImage(systemName: imageName)
            })
            .disposed(by: disposeBag)
        
        output.isEditing
            .subscribe(onNext: { [weak self] isEditing in
                self?.learnedTextField.isEnabled = isEditing
                self?.praisedTextField.isEnabled = isEditing
                self?.improvementTextField.isEnabled = isEditing
            })
            .disposed(by: disposeBag)
        
        output.reviseResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    //self.moveToHome()
                    print("회고록 수정 성공")
                } else {
                    print("회고록 수정 실패")
                }
            })
        
            .disposed(by: disposeBag)
        
        menuButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let response = output.memoirInquiryResult.value else { return }
                presentActionSheet(response)
            })
            .disposed(by: disposeBag)
    }
    
    /// 이모티콘 모달 띄우기
    private func presentModalEmoticonViewController() {
        let modalEmoticonViewController = ModalEmoticonViewController(viewModel: ModalEmoticonViewModel())
        modalEmoticonViewController.delegate = self
        modalEmoticonViewController.onImageSelected = { [weak self] imageUrl in
            self?.emoticonImage.kf.setImage(with: URL(string: imageUrl))
        }
        
        if #available(iOS 15.0, *) {
            if let sheet = modalEmoticonViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
        present(modalEmoticonViewController, animated: true, completion: nil)
    }
    
    private func updateUIWithMemoirResponse(_ response: MemoirResponse) {
        
        if let url = URL(string: response.result.emoticonUrl ?? "1") {
            emoticonImage.kf.setImage(with: url)
        }
        
        /// 날짜 정보 설정
        dateLabel.text = response.result.date
    
        /// 북마크 상태에 따라 아이콘 업데이트
        let bookmarkImageName = response.result.isBookmarked ?? false ? "bookmark.fill" : "bookmark"
        bookmarkButton.image = UIImage(systemName: bookmarkImageName)
        
        /// 회고록 답변 리스트에서 특정 요약 정보에 맞는 답변을 찾아서 UI 설정함
        if let learnedAnswer = response.result.memoirAnswerList.first(where: { $0.summary == "오늘 배운 점" }) {
            learnedTextField.text = learnedAnswer.answer
        } else {
            learnedTextField.text = "오늘의 회고를 작성해 보세요!"
        }
        
        if let praisedAnswer = response.result.memoirAnswerList.first(where: { $0.summary == "오늘 칭찬할 점" }) {
            praisedTextField.text = praisedAnswer.answer
        } else {
            praisedTextField.text = "오늘의 회고를 완료해 보세요"
        }
        
        if let improvementAnswer = response.result.memoirAnswerList.first(where: { $0.summary == "앞으로 개선할 점" }) {
            improvementTextField.text = improvementAnswer.answer
        } else {
            improvementTextField.text = "오늘의 회고를 작성해 보세요!"
        }
    }
    
    private func moveToHome() {
        let vc = HomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentActionSheet(_ response: MemoirResponse) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            self?.toggleEditingMode(isEditing: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            guard let self = self, let navigationController = navigationController else { return }
            
            if let date = response.result.date, let memoirId = response.result.memoirId {
                let deletedMemoirsPopUpView = DeletedMemoirsPopUpView(navigationController: navigationController, date: date, memoirId: memoirId)
                self.present(deletedMemoirsPopUpView, animated: true, completion: nil)
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    /// 네비게이션 바
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [menuButton, bookmarkButton]
    }
    
    private func toggleEditingMode(isEditing: Bool) {
        // 텍스트 필드 편집 가능 상태 변경
        learnedTextField.isEnabled = isEditing
        praisedTextField.isEnabled = isEditing
        improvementTextField.isEnabled = isEditing
        emoticonButton.isEnabled = isEditing
        
        // 네비게이션 바 업데이트
        updateNavigationBar(isEditing: isEditing)
    }
    
    private func updateNavigationBar(isEditing: Bool) {
        if isEditing {
            navigationItem.rightBarButtonItems = [reviceButton]
        } else {
            navigationItem.rightBarButtonItems = [menuButton, bookmarkButton]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    /// 리턴 키를 탭했을 때 키보드를 숨기는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension InquireMemoirsViewController: ModalEmoticonDelegate {
    func emoticonSelected(emoticon: Emoticon) {
        self.emoticonImage.kf.setImage(with: URL(string: emoticon.imageUrl),
                                       completionHandler:  { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    _ = KeychainWrapper.saveItem(value: String(emoticon.emoticonId),
                                                 forKey: MemoirsKeyChain.emoticonID.rawValue)
                }
            case .failure(_): break
            }
        })
    }
}
