//
//  TodayResolutionViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/2/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

final class TodayResolutionViewController: UIViewController {
    
    /// 스크롤 뷰
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        return view
    }()
    
    //contentView
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    //오늘의 다짐 타이틀 + 버튼 넣는 View
    private lazy var todayscontentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    /// 오늘의 다짐 타이틀
    private lazy var todayResolutionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 다짐"
        label.font = UIFont.pretendard(size: 25, weight: .bold)
        label.textColor = .OnOffPurple
        
        return label
    }()
    
    //오늘의 다짐 네비게이션 버튼
    private lazy var todayResolutionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .OnOffLightPurple
        button.tintColor = .OnOffPurple
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    /// 오늘의 다짐 띄워주는 뷰
    private lazy var resolutioncontentView: UIView = {
        let view = UIView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .OnOffLightPurple
        return view
    }()
    
    //오늘의 다짐안에 들어갈 초기문구
    private var resolutionwriteLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 지키고 싶은 다짐을 적어보세요!"
        label.backgroundColor = .clear
        label.font = UIFont.pretendard(size: 15, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
        private let viewModel: TodayResolutionViewModel
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: TodayResolutionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubViews()
        constraints()
        setupBindings()
    }
    
    /// Add SubViews
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(todayscontentView)
        todayscontentView.addSubview(todayResolutionTitleLabel)
        todayscontentView.addSubview(todayResolutionButton)
        contentView.addSubview(resolutioncontentView)
        resolutioncontentView.addSubview(resolutionwriteLabel)
        
        
    }
    
    /// Set Constraints
    private func constraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
        }
        
        todayscontentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(contentView).offset(30)
            make.height.equalTo(80)
            
        }
        
        todayResolutionTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(todayscontentView).offset(20)
        }
        
        todayResolutionButton.snp.makeConstraints { make in
            make.leading.equalTo(todayResolutionTitleLabel.snp.trailing).offset(10)
            make.centerY.equalTo(todayResolutionTitleLabel)
        }
        
        
        resolutioncontentView.snp.makeConstraints { make in
            make.top.equalTo(todayscontentView.snp.bottom).offset(10)
            make.leading.equalTo(todayscontentView).offset(20)
            make.trailing.equalTo(todayscontentView).offset(-20)
            make.height.equalTo(200)
        }
        
        resolutionwriteLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(resolutioncontentView)
        }
        
    }
    
    /// ViewModel과 bind
    private func setupBindings() {
        
        let input = TodayResolutionViewModel.Input(
            buttonTapped: todayResolutionButton.rx.tap.asObservable()
        )
        viewModel.bind(input: input)
    }
    
    
}
