//
//  BookmarkTableViewCell.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/03.
//

import UIKit
import SnapKit
import Kingfisher

/// BookmarkTableViewCell
final class BookmarkTableViewCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    /// 북마크 버튼
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.tintColor = .OnOffMain
        return button
    }()
    
    /// 날짜 label
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
    
    /// setupViews
    private func setupViews() {
        addSubviews()
    }
    
    /// addSubviews
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(dateLabel)
        addSubview(bookmarkButton)
        
        configureContraints()
    }
    
    /// configureContraints
    private func configureContraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(contentView.snp.height).multipliedBy(0.2)
        }
    }
    
    /// configure위치
    func configure(with memoir: Memoir, at indexPath: IndexPath) {
        dateLabel.text = memoir.date
        
        if let url = URL(string: memoir.emoticonUrl ?? "") {
            iconImageView.kf.setImage(with: url)
        }
        
        iconImageView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.8)
            
            if let remain = memoir.remain, remain % 2 == 0 {
                make.leading.equalToSuperview().inset(-10)
            } else {
                make.trailing.equalToSuperview().inset(-10)
            }
        }
        
    }
}
