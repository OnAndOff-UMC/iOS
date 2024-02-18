//
//  AddWriteViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
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
    
    //addview - Field + AddButton
    private lazy var addView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //textfield
    private lazy var textfield: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.placeholder = "오늘의 다짐을 적어봐요"
        return tf
    }()
    
    //textfieldline
    private lazy var textfieldline: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "textfieldline")
        return iv
    }()
    
    //writeplusbutton
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named:"plusButton"), for: .normal)
        return button
    }()
    
    /// customBackButton
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: nil, action: nil)
        button.tintColor = .black
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
    
    // TableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
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
        
        view.backgroundColor = .white
        addSubViews()
        constraints()
        setupNavigationBar()
        setupBindings()
    }
    
    /// Add SubViews
    private func addSubViews() {
        
        view.addSubview(contentView)
        contentView.addSubview(addView)
        addView.addSubview(textfield)
        addView.addSubview(textfieldline)
        addView.addSubview(plusButton)
        contentView.addSubview(tableView)
        
    }
    
    /// Set Constraints
    private func constraints() {
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(100)
        }
        
        textfield.snp.makeConstraints { make in
            make.leading.equalTo(addView).offset(20)
            make.top.equalTo(addView).offset(30)
        }
        
        textfieldline.snp.makeConstraints { make in
            make.top.equalTo(textfield.snp.bottom).offset(8)
            make.leading.equalTo(addView).inset(20)
            make.trailing.equalTo(addView).inset(70)
            make.height.equalTo(2)
            make.trailing.equalTo(plusButton).inset(5)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(addView).inset(20)
            make.top.equalTo(addView).offset(30)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    /// 네비게이션 바
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    /// 뷰모델과 setupBindings
    private func setupBindings() {
//        // 텍스트 필드 입력과 버튼 탭을 뷰모델에 바인딩합니다.
//        let input = AddWriteViewModel.Input(
//            backButton: backButton.rx.tap.asObservable(),
//            saveButton: saveButton.rx.tap.asObservable(),
//            plusButton: plusButton.rx.tap.asObservable(),
////            textInput: textfield.rx.text.orEmpty.asControlProperty()
//        )
//
//        // 뷰모델과 바인딩하여 테이블 뷰 데이터를 구독합니다.
//        let output = viewModel.bind(input: input)
//        output.tableData
//            .map { $0.map { $0 as String } } // 배열 요소를 String으로 변환합니다.
//            .drive(tableView.rx.items(cellIdentifier: "cell")) { (index, text, cell) in
//                cell.textLabel?.text = text
//            }
//            .disposed(by: disposeBag)
    }
    
}
