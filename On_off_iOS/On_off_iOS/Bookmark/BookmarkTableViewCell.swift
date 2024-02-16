//
//  BookmarkTableViewCell.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/03.
//

import UIKit
import SnapKit
import Kingfisher

final class BookmarkTableViewCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var bookmarkButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            button.tintColor = .OnOffMain
            return button
        }()
    
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
        addSubviews()
        
        
    }
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(dateLabel)
        addSubview(bookmarkButton)
        
        configureContraints()
    }
    private func configureContraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints { make in
              make.top.equalToSuperview().offset(10)
              make.trailing.equalToSuperview().offset(-10)
          }
    }
    
    func configure(with memoir: Memoir, at indexPath: IndexPath) {
        dateLabel.text = memoir.date
        
        if let url = URL(string: memoir.emoticonUrl ?? "") {
                   iconImageView.kf.setImage(with: url)
               }
        
        iconImageView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.8)
            
            if let remain = memoir.remain, remain % 2 == 0 {
                make.leading.equalToSuperview().offset(10)
            } else {
                make.trailing.equalToSuperview().offset(-10)
            }
        }
        
    }
}
