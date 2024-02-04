//
//  BookmarkTableViewCell.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/03.
//

import UIKit
import SnapKit

final class BookmarkTableViewCell: UITableViewCell {
    
    private lazy var iconImageView = UIImageView()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(dateLabel)
        
        iconImageView.contentMode = .scaleAspectFit
        dateLabel.textAlignment = .center
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with item: Item, at indexPath: IndexPath) {
        dateLabel.text = item.title
        iconImageView.image = item.image
        iconImageView.backgroundColor = .blue
        
        iconImageView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(iconImageView.snp.height)
            
            if indexPath.row % 2 == 0 {
                make.leading.equalToSuperview().offset(10)
            } else {
                make.trailing.equalToSuperview().offset(-10)
            }
        }
    }
}

/// 더미 데이터 예시 형식임 ❎
struct Item {
    var title: String
    var image : UIImage
}
