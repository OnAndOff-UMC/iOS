//
//  HomeViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    private let items: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private let items2: [String] = ["18", "19", "20", "21", "22", "23", "24"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Create UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10 // Adjust the interitem spacing between cells

        // Create UICollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCellReuseIdentifier")
        view.addSubview(collectionView)

        // Set up constraints using SnapKit
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(100) // Set the height based on your preference
        }

        // Bind data to the collection view using RxSwift
        Observable.just(items.enumerated().map { "\($0.element)\n\(items2[$0.offset])" })
            .bind(to: collectionView.rx.items(cellIdentifier: "DateCellReuseIdentifier", cellType: DateCell.self)) { (_, element, cell) in
                cell.configureCell(date: element)
            }
            .disposed(by: disposeBag)

        // Handle item selection
        collectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { item in
                print("Selected: \(item)")
            })
            .disposed(by: disposeBag)
    }
}

class DateCell: UICollectionViewCell {
    private let ovalButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25 // Adjust the radius based on your preference
        button.clipsToBounds = true
        button.backgroundColor = .dateunpick
        return button
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2 // Allow multiple lines
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(ovalButton)
        ovalButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(contentView.snp.height) // Set width equal to height for a perfect circle
            make.height.equalTo(contentView.snp.height)
        }

        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalTo(ovalButton)
        }
    }

    func configureCell(date: String) {
        dateLabel.text = date
    }
}
