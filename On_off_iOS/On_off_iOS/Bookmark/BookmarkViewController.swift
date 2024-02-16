//
//  BookmarkViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BookmarkViewController: UIViewController {
    
    private lazy var tableView = UITableView()
    
    private let viewModel: BookmarkViewModel
    private let disposeBag = DisposeBag()
    private var loadDataSubject: PublishSubject<Void> = PublishSubject<Void>()
    
    // MARK: - Init
    init(viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataSubject.onNext(())
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: CellIdentifier.BookmarkTableViewCell.rawValue)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        let input = BookmarkViewModel.Input(
            reloadDataEvents: loadDataSubject.asObservable(),
            cellTapped: tableView.rx.itemSelected.asObservable(),
            bookmarkButtonTapped: .never()
        )
        
        let output = viewModel.bind(input: input)
        
        output.memoirList
              .observeOn(MainScheduler.instance)
              .subscribe(onNext: { [weak self] memoirList in
                  guard let self = self else { return }
                  self.tableView.reloadData()
              })
              .disposed(by: disposeBag)
    
        output.memoirList
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifier.BookmarkTableViewCell.rawValue, cellType: BookmarkTableViewCell.self)) { (index, memoir, cell) in
                cell.configure(with: memoir, at: IndexPath(row: index, section: 0))
            }
            .disposed(by: disposeBag)
    }
}

/// UITableViewDelegate
extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.2
    }
}
