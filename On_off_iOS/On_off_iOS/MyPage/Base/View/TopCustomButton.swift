//
//  TopCustomButton.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/15/24.
//

import Foundation
import UIKit

final class TopCustomButton: UIButton {
    
    /// 아이콘 이미지
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 제목 라벨
    private lazy var topTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add SubViews
    private func addSubViews() {
        addSubview(iconImageView)
        addSubview(topTitleLabel)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(topTitleLabel.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        }
        
        topTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    /// Input Data
    /// - Parameters:
    ///   - icon: 아이콘
    ///   - title: 제목
    func inputData(icon: String, title: String) {
        iconImageView.image = UIImage(named: icon)
        topTitleLabel.text = title
    }
}
