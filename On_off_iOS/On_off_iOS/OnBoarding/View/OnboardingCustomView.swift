//
//  OnboardingCustomView.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import UIKit
import SnapKit

final class OnboardingCustomView: UIView {
    private let imageView = UIImageView()
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

    private func setupViews() {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(titleLabel)

        imageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    func configure(imageName: String, text: String) {
        imageView.image = UIImage(named: imageName)
        titleLabel.text = text
    }
}

