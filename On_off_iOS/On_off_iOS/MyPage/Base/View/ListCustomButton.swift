//
//  ListCustomButton.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/15/24.
//

import Foundation
import SnapKit
import UIKit

final class ListCustomButton: UIButton {
    
    /// 아이콘 이미지
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 제목 라벨
    private lazy var title: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    /// 오른쪽 사이드 라벨
    private lazy var rightSideLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .medium)
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
        addSubview(title)
        addSubview(rightSideLabel)
        
        constraints()
    }
    var leading: Constraint?
    /// Constraints
    private func constraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.verticalEdges.equalToSuperview().inset(5)
        }
        
        title.snp.makeConstraints { make in
            leading = make.leading.equalTo(iconImageView.snp.trailing).constraint
            make.centerY.equalToSuperview()
        }
        
        rightSideLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.verticalEdges.equalToSuperview().inset(5)
        }
        
    }
    
    /// Input Data
    /// - Parameters:
    ///   - icon: 아이콘
    ///   - title: 제목
    func inputData(icon: String?, title: String, titleColor: UIColor, rightSide: String, rightSideImage: String?) {
        if let icon = icon {
            iconImageView.image = UIImage(named: icon)
            leading?.update(offset: 10)
        }
        self.title.text = title
        self.title.textColor = titleColor
        
        if let rightSideImage = rightSideImage {
            let imageAttachment = NSTextAttachment(image: UIImage(named: rightSideImage) ?? UIImage())
            let attributedString = NSMutableAttributedString(attachment: imageAttachment)
            rightSideLabel.attributedText = attributedString
            return
        }
        rightSideLabel.text = rightSide
    }
}
