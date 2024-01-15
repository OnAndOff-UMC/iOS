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
    var viewModel: OnBoardingViewModel

    private let customPageControl = CustomPageControl()
    private let nextButton = UIButton(type: .system)
    private let disposeBag = DisposeBag()
    
    /// 현재 페이지 상태를 관리
    private var currentPage = BehaviorRelay<Int>(value: 0)
    private let totalPages = 3
    
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
        setupScrollView()
        setupCustomPageControl()
        setupNextButton()
        setupBindings()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        setupContentView()
    }
    private func setupContentView() {
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width).multipliedBy(totalPages)
        }
        
        setupOnboardingViews(in: contentView)
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
    
    private func setupCustomPageControl() {
        customPageControl.numberOfPages = totalPages
        view.addSubview(customPageControl)
        
        customPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
        }
    }
    
    private func setupNextButton() {
        nextButton.setTitle("다음", for: .normal)
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func setupBindings() {
        let startButtonTapOnLastPage = nextButton.rx.tap
            .withLatestFrom(currentPage.asObservable())
            .filter { [weak self] page in
                guard let self = self else { return false }
                return page == self.totalPages - 1
            }
            .map { _ in Void() }
        
        let input = OnBoardingViewModel.Input(
            startButtonTapped: startButtonTapOnLastPage
        )
        
        let output = viewModel.bind(input: input)
        
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
