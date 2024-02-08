//
//  AddWriteViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/6/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit
import SnapKit

final class AddWriteViewController: UIViewController {
    
    //contentView
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    /// customBackButton
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: nil, action: nil)
        button.tintColor = .OnOffBackButton
        return button
    }()
    
    // 오늘의 다짐 Title - 네비게이션
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 다짐 추가"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    /// 메뉴 버튼 - 네비게이션 바
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
        button.tintColor = .systemBlue
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                print("저장 로직 구현")
                
            })
            .disposed(by: disposeBag)
        
        return button
    }()
    
    
    private let viewModel: AddWriteViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: AddWriteViewModel) {
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
        
//        navigationItem.rightBarButtonItem = saveButton
        
        
        view.backgroundColor = .white
        addSubViews()
        constraints()
        setupNavigationBar()
        setupBindings()
    }
    
    /// Add SubViews
    private func addSubViews() {
        
        view.addSubview(contentView)
        
    }
    
    /// Set Constraints
    private func constraints() {
        
        
    }
    
    /// 네비게이션 바
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
        let input = AddWriteViewModel.Input(backButton: backButton.rx.tap.asObservable(),saveButton: saveButton.rx.tap.asObservable())
        
        let _ = viewModel.bind(input: input)
        

    }
    
    
    
    
    
}
