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
          let button = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: nil, action: nil)
          button.rx.tap
              .subscribe(onNext: { [weak self] in
                  print("북마크 로직 구현")
              })
              .disposed(by: disposeBag)
          return button
      }()

    /// 메뉴 버튼 - 네비게이션 바
      private lazy var menuButton: UIBarButtonItem = {
          let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis")?.rotated(by: .pi / 2), style: .plain, target: nil, action: nil)
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

    /// +버튼
      private lazy var writeButton: UIButton = {
          let button = UIButton()
          button.setImage(UIImage(systemName: "plus"), for: .normal)
          button.tintColor = .white
          button.backgroundColor = .purple
          button.layer.cornerRadius = 25
          button.layer.masksToBounds = true
          return button
      }()
    
    /// emoticon View
    private lazy var emoticonView: UIView = {
        let label = UILabel()
        return label
    }()
    
    /// emoticon label
    private lazy var emoticonLabel: UILabel = {
        let label = UILabel()
        label.text = "이모티콘"
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        return label
    }()
    
    /// date label
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨 정보"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// 오늘 배운 점 label
    private lazy var learnedLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 배운 점"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// 오늘 배운 점 View
    private lazy var learnedView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    /// 칭찬할 점 label
    private lazy var praisedLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 칭찬할 점"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    /// 칭찬할 점 View
    private lazy var praisedView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    /// 개선할 점 label
    private lazy var improvementLabel: UILabel = {
        let label = UILabel()
        label.text = "앞으로 개선할 점"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// 개선할 점 View
    private lazy var improvementView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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
        view.backgroundColor = .white
        addSubviews()
        setupBindings()
    }
    
    /// addSubviews
    private func addSubviews(){
        setupNavigationBar()
        view.addSubview(scrollView)
        view.addSubview(writeButton)
        
        contentView.addSubview(emoticonView)
        emoticonView.addSubview(emoticonLabel)
        
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
        emoticonLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
    }
    
    /// 네비게이션 바
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [menuButton, bookmarkButton]
        }
    }

/// 이미지 90도 회전
extension UIImage {
    func rotated(by radians: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        /// 기준점을 이미지 중앙으로 이동
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        /// 주어진 각도만큼 회전
        context.rotate(by: radians)
        /// 이미지를 새 위치에 그리기
        context.draw(cgImage, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}
