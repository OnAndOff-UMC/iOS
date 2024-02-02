//
//  EmoticonCollectionViewCell.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import SnapKit
import UIKit
import Kingfisher

final class EmoticonCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    ///이미지
    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
}

