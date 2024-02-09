//
//  EmoticonCollectionViewCell.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import SnapKit
import UIKit
import SVGKit
//import Kingfisher

final class EmoticonCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// setupViews
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    ///이미지
    func configure(with imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        DispatchQueue.global().async {
            let svgImage: SVGKImage? = SVGKImage(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = svgImage?.uiImage
            }
        }
    }
}

