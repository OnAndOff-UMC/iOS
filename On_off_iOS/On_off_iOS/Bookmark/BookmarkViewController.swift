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
    // 더미 데이터❎
    var items = PublishSubject<[Item]>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: CellIdentifier.BookmarkTableViewCell.rawValue)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        items.bind(to: tableView.rx.items(cellIdentifier: CellIdentifier.BookmarkTableViewCell.rawValue, cellType:BookmarkTableViewCell.self)) { (row, item, cell) in
            cell.configure(with: item, at: IndexPath(row: row, section: 0))
        }.disposed(by: disposeBag)
        
        // 더미 데이터 생성, 바인딩
        let dummyItems = (1...20).map { Item(title: "Item \($0)", image: UIImage(named: "AppIcon") ?? UIImage()) }
        items.onNext(dummyItems)
    }
}

extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.2
    }
}
