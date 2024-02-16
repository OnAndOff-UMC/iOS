//
//  ModalSelectProfileViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/05.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

final class ModalSelectProfileViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .OnOffMain
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(ModalSelectProfileTableViewCell.self, forCellReuseIdentifier: CellIdentifier.ModalSelectProfileTableViewCell.rawValue)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let viewModel: ModalSelectProfileViewModel
    private let disposeBag = DisposeBag()
    private var dataType: ProfileDataType

    var onImageSelected: ((String) -> Void)?
    
    weak var delegate: ModalSelectProfileDelegate?

    // MARK: - Init
    init(viewModel: ModalSelectProfileViewModel, dataType: ProfileDataType) {
        self.viewModel = viewModel
        self.dataType = dataType
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    /// setupViews
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(tableView)
    }
    
    /// setupConstraints
    private func setupConstraints() {
        
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(30)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// setupBindings
    private func setupBindings() {
        let input = ModalSelectProfileViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.bind(input: input, dataType: dataType)
        
        /// 옵션 바인딩
        bindingOptions(output)
        
        /// 라벨 바인딩
        bindingLabelText(output)
        
        /// 테이블뷰 바인딩
        bindingTableView(output)
 
    }
    private func bindingOptions(_ output: ModalSelectProfileViewModel.Output) {
        output.options
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifier.ModalSelectProfileTableViewCell.rawValue, cellType: ModalSelectProfileTableViewCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindingLabelText(_ output: ModalSelectProfileViewModel.Output) {
        output.labelText
               .bind(to: label.rx.text)
               .disposed(by: disposeBag)
    }
    
    private func bindingTableView(_ output: ModalSelectProfileViewModel.Output) {
        tableView.rx.modelSelected(String.self)
            .bind { [weak self] selectedOption in
                self?.delegate?.optionSelected(data: selectedOption, dataType: self?.dataType ?? .fieldOfWork)
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
