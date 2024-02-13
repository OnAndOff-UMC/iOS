//
//  OnboardingCustomView.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import UIKit
import SnapKit

/// OnboardingCustomView
final class OnboardingCustomView: UIView {
    
    /// 온보딩 이미지뷰
    private lazy var onboardingImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 온보딩 글
    private let titleLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    /// setupViews
    private func setupViews() {
        backgroundColor = .white
        addSubview(onboardingImageView)
        addSubview(titleLabel)

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        onboardingImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(onboardingImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    /// configure
    func configure(imageName: String, text: NSAttributedString) {
        onboardingImageView.image = UIImage(named: imageName)
        titleLabel.attributedText = text
    }
}

