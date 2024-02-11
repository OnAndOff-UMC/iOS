//
//  ExpressedIconViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/28.
//

import UIKit
import RxSwift
import RxCocoa
import SVGKit

/// ExpressedIconViewController
final class ExpressedIconViewController: UIViewController {
    
    /// customBackButton
    private let backButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: MemoirsText.getText(for: .backButton), style: .plain, target: nil, action: nil)
        button.tintColor = .black
        return button
    }()
    
    /// pageControl
    private lazy var pageControlImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.PageControl5.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// welcomeLabel
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = MemoirsText.getText(for: .iconSelection)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    /// 회고록 작성페이지 그림
    private lazy var textpageImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: MemoirsImage.TextpageImage4.rawValue))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 이모티콘 이미지
    private lazy var emoticonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        view.backgroundColor = .OnOffMain
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
        settingView()
        addSubviews()
        setupBindings()
        settingCheckButtonView()
    }
    
    private func settingView(){
        view.backgroundColor = .OnOffLightMain
    }
    
    /// 확인 버튼 속성 설정
    private func settingCheckButtonView(){
        let cornerRadius = UICalculator.calculate(for: .longButtonCornerRadius, width: view.frame.width)
        saveButtonView.layer.cornerRadius = cornerRadius
        saveButtonView.layer.masksToBounds = true
    }
    
    /// addSubviews
    private func addSubviews() {
        
        view.addSubview(pageControlImage)
        view.addSubview(welcomeLabel)
        
        view.addSubview(textpageImage)
        view.addSubview(emoticonImage)
        
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
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
        
        emoticonImage.snp.makeConstraints { make in
            make.center.equalTo(textpageImage.snp.center)
            make.height.width.equalTo(textpageImage.snp.height).multipliedBy(0.8)
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
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = ExpressedIconViewModel.Input(startButtonTapped: saveButton.rx.tap.asObservable(),
                                                 backButtonTapped: backButton.rx.tap.asObservable())
        
        // 이미지 뷰 탭 제스처에 대한 바인딩
        textpageImage.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presentModalEmoticonViewController()
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.bind(input: input)

        output.moveToNext
            .subscribe(onNext: { [weak self] _ in
                    self?.navigateTobookMark()
            })
            .disposed(by: disposeBag)
        
        output.moveToBack
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?
                .popViewController(animated: false)})
        
    }
    /// 임시 초기로 이동
    private func navigateTobookMark() {
        let bookmarkViewModel = BookmarkViewModel()
        let writePraisedViewController = BookmarkViewController(viewModel: bookmarkViewModel)
        self.navigationController?.pushViewController(writePraisedViewController, animated: false)
    }
    
    /// 이모티콘 모달 띄우기
    private func presentModalEmoticonViewController() {
        let modalEmoticonViewController = ModalEmoticonViewController(viewModel: ModalEmoticonViewModel())
        modalEmoticonViewController.delegate = self
        modalEmoticonViewController.onImageSelected = { [weak self] imageUrl in
            if let svgImage = SVGKImage(contentsOf: URL(string: imageUrl)) {
                self?.emoticonImage.image = svgImage.uiImage
            }
        }

        if #available(iOS 15.0, *) {
            if let sheet = modalEmoticonViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
        present(modalEmoticonViewController, animated: true, completion: nil)
    }
}

extension ExpressedIconViewController: ModalEmoticonDelegate {
    func emoticonSelected(emoticon: Emoticon) {
        if let svgURL = URL(string: emoticon.imageUrl), let svgImage = SVGKImage(contentsOf: svgURL) {
            self.emoticonImage.image = svgImage.uiImage
        } else {
            print("SVG 이미지 로드 실패")
        }
    }
}
