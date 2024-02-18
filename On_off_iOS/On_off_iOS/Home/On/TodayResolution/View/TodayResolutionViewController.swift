//
//  TodayResolutionViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

final class TodayResolutionViewController: UIViewController, UITextFieldDelegate {
    
    /// 메뉴 버튼 - 네비게이션 바
    private lazy var menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: MemoirsImage.ellipsis.rawValue)?.rotated(by: .pi / 2),
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        return button
    }()
    
    /// 저장 버튼 - 네비게이션 바
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
        return button
    }()
    
    /// 삭제 버튼 - 네비게이션 바
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "삭제", style: .plain, target: nil, action: nil)
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
       //오늘의 다짐 tableview여기에 추가
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
    
//    /// 오늘의 다짐 네비게이션 버튼
//    private lazy var todayResolutionButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .OnOffLightPurple
//        button.tintColor = .OnOffPurple
//        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        return button
//    }()
//
    
    /// resolutionTextField
    private lazy var resolutionTextField: UITextField = {
        let field = UITextField()
        field.textAlignment = .left
        field.backgroundColor = UIColor.clear
        field.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        field.layer.borderColor = UIColor.clear.cgColor
        field.isEnabled = false
        field.textColor = .black
        
        return field
    }()
    
    /// resolutionView
    private lazy var resolutionView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "오늘의다짐뷰")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
//        addSubViews()
        constraints()
//        setupBindings()
    }
    
//    /// Add SubViews
//    private func addSubViews() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(todayscontentView)
//        todayscontentView.addSubview(todayResolutionTitleLabel)
//        contentView.addSubview(resolutionTextField)
//        resolutionView.addSubview(resolutionTextField)
//
//        
//    }
    
    /// Set Constraints
    private func constraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(1000)
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
        
//        todayResolutionButton.snp.makeConstraints { make in
//            make.leading.equalTo(todayResolutionTitleLabel.snp.trailing).offset(10)
//            make.centerY.equalTo(todayResolutionTitleLabel)
//        }
//        
//        
//        resolutioncontentView.snp.makeConstraints { make in
//            make.top.equalTo(todayscontentView.snp.bottom).offset(10)
//            make.leading.equalTo(todayscontentView).offset(20)
//            make.trailing.equalTo(todayscontentView).offset(-20)
//            make.height.equalTo(200)
//        }
//        
//        resolutionwriteLabel.snp.makeConstraints { make in
//            make.centerX.centerY.equalTo(resolutioncontentView)
//        }
        
    }
//    
//    /// ViewModel과 bind
//    private func setupBindings() {
//        
//        let input = TodayResolutionViewModel.Input(
//            buttonTapped: todayResolutionButton.rx.tap.asObservable()
//        )
//        viewModel.bind(input: input)
//    }
//    
    
}
