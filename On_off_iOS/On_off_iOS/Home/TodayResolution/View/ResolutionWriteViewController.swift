//
//  ResolutionWriteViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/4/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit
import SnapKit

final class ResolutionWriteViewController: UIViewController {
    
    /// customBackButton
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: nil, action: nil)
        button.tintColor = .OnOffBackButton
        return button
    }()
    
    // 오늘의 다짐 Title - 네비게이션
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 다짐"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    /// 메뉴 버튼 - 네비게이션 바
    private lazy var menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: nil, action: nil)
        button.tintColor = .OnOffBackButton
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                print("메뉴 로직 구현")
            })
            .disposed(by: disposeBag)
        return button
    }()
    
    //contentView
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
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
    
    private let viewModel: ResolutionWriteViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: ResolutionWriteViewModel) {
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
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleLabel

        
        view.backgroundColor = .white
        addSubViews()
        constraints()
        setupNavigationBar()
    }
    
    /// Add SubViews
    private func addSubViews() {
        
        view.addSubview(contentView)
        contentView.addSubview(resolutioncontentView)
        resolutioncontentView.addSubview(resolutionwriteLabel)
        
    }
    
    /// Set Constraints
    private func constraints() {
                
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        resolutioncontentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(200)
        }
        
        resolutionwriteLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(resolutioncontentView)
        }
        
    }
    
    /// 네비게이션 바
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [menuButton]
    }
    
    
    
}
