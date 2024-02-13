//
//  MenuModalViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/5/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit
import SnapKit

final class MenuModalViewController: UIViewController {
    
    //contentView
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    //추가하기 버튼
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(size: 20, weight: .medium)
        return button
    }()
    
    //수정하기 버튼
    private let modifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.backgroundColor = .clear
       // button.setTitleColor(.OnOffBackButton, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(size: 20, weight: .medium)
        return button
    }()
    
    
    //제거하기 버튼
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(size: 20, weight: .medium)
        return button
    }()
    
    //세로 줄
    private lazy var lineView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    //세로 줄2
    private lazy var lineView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    private let viewModel: MenuModalViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: MenuModalViewModel) {
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
        view.addSubview(contentView)
        contentView.addSubview(addButton)
        contentView.addSubview(modifyButton)
        contentView.addSubview(removeButton)
        contentView.addSubview(lineView)
        contentView.addSubview(lineView2)
        
    }
    
    /// Set Constraints
    private func constraints() {
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(52)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
        }
        
        modifyButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(modifyButton.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        
    }
    
    /// ViewModel과 bind
    private func setupBindings() {
        let input = MenuModalViewModel.Input(addButton: addButton.rx.tap.asObservable(),
                                             modifyButton: modifyButton.rx.tap.asObservable(),removeButton: removeButton.rx.tap.asObservable())
        viewModel.bind(input: input)
    
    }
    
//    //
//    private func showAddModal() {
//        guard let navigationController = navigationController else {
//            print("Error: navigationController is nil")
//            return
//        }
//        
//        let addWriteViewModel = AddWriteViewModel(navigationController: navigationController)
//        let addWriteView = AddWriteViewController(viewModel: addWriteViewModel)
//        navigationController.pushViewController(addWriteView, animated: true)
//    }
    
}
