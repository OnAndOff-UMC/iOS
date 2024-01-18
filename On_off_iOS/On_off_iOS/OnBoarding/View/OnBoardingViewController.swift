//
//  OnBoardingViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OnBoardingViewController : UIViewController {
    
    // MARK: - Properties
    // 스크롤 뷰: 온보딩 페이지를 표시
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    let contentView = UIView()
        
    /// 현재 페이지 상태를 관리
    private var currentPage = BehaviorRelay<Int>(value: 0)
    private let totalPages = 3
    
    private let customPageControl : CustomPageControl = {
        let customPageControl = CustomPageControl()
        customPageControl.numberOfPages = 3
        return customPageControl
    }()
    
    /// 다음, 건너뛰기 버튼아래 뷰
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    /// 다음버튼
    private let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음 >", for: .normal)
        return button
    }()
    
    /// 건너뛰기 버튼
    private let jumpButton : UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private var viewModel: OnBoardingViewModel

    // MARK: - Init
    init(viewModel: OnBoardingViewModel) {
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
        addSubViews()
        setupBindings()

    }
    private func setupUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true

    }
    /// 온보딩 뷰들을 설정
    private func setupOnboardingViews(in contentView: UIView) {
        let onboardingData: [OnboardingItem] = [
            OnboardingItem(imageName: "온보딩1", text: "퇴근길 회고하며 이제\n일에서 완전히 로그아웃하세요"),
            OnboardingItem(imageName: "온보딩2", text: "왜 자꾸 실수할까?\n쌓인 회고들이 나를 성장시킬거예요"),
            OnboardingItem(imageName: "온보딩3", text: "on & off로\n일과 삶의 밸런스를 관리해요!")
        ]
        /// 이전 뷰 추적함
        var previousView: UIView?
        
        /// 각 온보딩 데이터 아이템에 대한 뷰 생성함
        for (index, data) in onboardingData.enumerated() {
            let onboardingView = OnboardingCustomView()
            contentView.addSubview(onboardingView)
            onboardingView.configure(imageName: data.imageName, text: data.text)
            
            /// 온보딩 뷰 constraints 설정
            onboardingView.snp.makeConstraints { make in
                make.top.equalTo(contentView).inset(50)
                make.bottom.equalTo(contentView)
                make.width.equalTo(scrollView)
                
                /// 이전 뷰가 있으면 그 뒤에 배치, 없으면 컨텐트 뷰의 시작 부분에 배치
                if let previousView = previousView {
                    make.leading.equalTo(previousView.snp.trailing)
                } else {
                    make.leading.equalTo(contentView)
                }
                
                if index == onboardingData.count - 1 {
                    make.trailing.equalTo(contentView)
                }
            }
            previousView = onboardingView
        }
    }
    
    /// addSubViews
    private func addSubViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(customPageControl)
        view.addSubview(buttonView)
        buttonView.addSubview(nextButton)
        buttonView.addSubview(jumpButton)

        configureConstraints()
        setupOnboardingViews(in: contentView)

    }
    
    /// configureConstraints
    private func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width).multipliedBy(totalPages)
        }
        
        customPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
        }
        
        /// Bottom button View
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(buttonView.snp.width).multipliedBy(0.2)
        }
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(30)
        }
        jumpButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    /// ViewModel과 bind
    private func setupBindings() {
        let startButtonTapOnLastPage = nextButton.rx.tap
            .withLatestFrom(currentPage.asObservable())
            .filter { [weak self] page in
                guard let self = self else { return false }
                return page == self.totalPages - 1
            }
            .map { _ in Void() }
        
        let input = OnBoardingViewModel.Input(
            startButtonTapped: startButtonTapOnLastPage, 
            jumpButtonTapped: jumpButton.rx.tap.asObservable()
        )
        
        let _ = viewModel.bind(input: input)
        
        // 나머지 페이지에서 버튼이 눌렸을 때의 동작
        nextButton.rx.tap
            .withLatestFrom(currentPage.asObservable())
            .filter { [weak self] page in
                guard let self = self else { return false }
                return page < self.totalPages - 1
            }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let nextPage = (self.currentPage.value + 1) % self.totalPages
                self.currentPage.accept(nextPage)
            }).disposed(by: disposeBag)
        
        // 현재 페이지 변경 감지
        currentPage.subscribe(onNext: { [weak self] page in
            guard let self = self else { return }
            
            let isLastPage = page == totalPages - 1
            self.nextButton.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().inset(17)
                make.bottom.equalToSuperview().inset(30)
            }
                self.jumpButton.isHidden = false

               
            // 마지막 페이지인 경우
               if isLastPage {
                   self.nextButton.snp.remakeConstraints { make in
                       make.centerX.equalToSuperview()
                       make.bottom.equalToSuperview().inset(30)
                   }
                   self.jumpButton.isHidden = true
               }
            
            let buttonTitle = page == self.totalPages - 1 ? "시작하기" : "다음"
            self.nextButton.setTitle(buttonTitle, for: .normal)
            
            let xOffset = CGFloat(page) * self.view.frame.width
            UIView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
                self.scrollView.contentOffset = CGPoint(x: xOffset, y: 0)
            }, completion: nil)
            
            self.customPageControl.currentPage = page
        }).disposed(by: disposeBag)
    }
    
}

// MARK: Extension - UIScrollViewDelegate
extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customPageControl.updateForScroll(offsetX: scrollView.contentOffset.x, scrollViewWidth: scrollView.frame.width)
    }
}
