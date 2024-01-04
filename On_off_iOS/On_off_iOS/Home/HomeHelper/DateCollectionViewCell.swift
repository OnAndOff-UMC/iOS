//
//  DateCollectionViewCell.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/4/24.
//

import Foundation
import UIKit
import SnapKit

class DateCollectionViewCell: UICollectionViewCell {

    private let ovalButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20 // 타원의 세로 길이에 따라 조절
        button.clipsToBounds = true
        button.backgroundColor = UIColor.customPurple
        return button
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
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
            make.width.equalTo(50) // 타원의 가로 길이에 따라 조절
            make.height.equalTo(80) // 타원의 세로 길이에 따라 조절
            make.center.equalToSuperview()
        }

        ovalButton.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureCell(date: String) {
        dateLabel.text = date
    }
}


