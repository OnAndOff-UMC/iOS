//
//  ModalSelectProfileTableViewCell.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/05.
//

import UIKit
import SnapKit

final class ModalSelectProfileTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup Views
    private func setupViews() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        contentView.backgroundColor = .white
    }
    
    func configure(with text: String) {
        self.label.text = text
    }
}
