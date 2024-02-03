//
//  TodayResolutionViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/2/24.
//

import Foundation
import RxSwift
import RxRelay
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
    
//    /// StackView - 오늘의 다짐, 오늘의 다짐 네비게이션 버튼
//    private lazy var stackView: UIStackView = {
//        let view = UIStackView(arrangedSubviews: [todayResolutionTitleLabel, todayResolutionButton])
//        view.backgroundColor = .clear
//        view.axis = .horizontal
//        view.spacing = 5  // 또는 충돌하지 않는 적절한 값으로 변경
//        view.distribution = .fillProportionally
//        return view
//    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    /// 오늘의 다짐 타이틀
    private lazy var todayResolutionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 다짐"
        label.backgroundColor = .clear
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        label.textColor = .OnOffPurple
        return label
    }()
    
    //오늘의 다짐 네비게이션 버튼
    private lazy var todayResolutionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .OnOffPurple
        button.setImage(UIImage(named: "chevron.right"), for: .normal)
        return button
    }()
    
    /// 오늘의 다짐 contentVIew
    private lazy var todayresolutioncontentView: UIView = {
        let view = UIView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.tintColor = .OnOffLightPurple
        return view
    }()
    
    //오늘의 다짐안에 들어갈 초기문구
    private var todayresolutionwriteLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 지키고 싶은 다짐을 적어보세요!"
        label.backgroundColor = .clear
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    //    private let viewModel: TodayResolutionViewModel = TodayResolutionViewModel()
    //    private var output: TodayResolutionViewModel.Output?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubViews()
        //        bind()
        constraints()
    }
    
    /// Add SubViews
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(todayResolutionTitleLabel)
        contentView.addSubview(todayResolutionButton)
        scrollView.addSubview(todayresolutioncontentView)
        todayresolutioncontentView.addSubview(todayresolutionwriteLabel)
        
    }
    
    /// Set Constraints
    private func constraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(100)
            
        }
        
        todayResolutionTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(20)
            //top 위치 버튼이랑 같아야함., horizontal그거 다시
        }

        todayResolutionButton.snp.makeConstraints { make in
          
        }

        
        todayresolutioncontentView.snp.makeConstraints { make in
            
        }
        
        todayresolutionwriteLabel.snp.makeConstraints { make in
            make.center.equalTo(todayresolutioncontentView) // 중앙에 위치
            make.edges.equalTo(todayresolutioncontentView).inset(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        }
        
    }




    
    
    //    /// Binding
    //    private func bind() {
    //        let output = viewModel.createoutput(input: StatisticsViewModel.Input(prevButtonEvents: prevMonthButton.rx.tap,
    //                                                                             nextButtonEvents: nextMonthButton.rx.tap))
    //        self.output = output
    //        bindWeekView(output: output)
    //        bindMonthView(output: output)
    //        bindWriteRateUILabel(output: output)
    //        bindMonthButtonAction(output: output)
    //    }
    
    
    
    
}
