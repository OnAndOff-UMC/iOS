//
//  LogOptionButton.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation
import UIKit
import SnapKit

final class LogOptionButton: UIButton {
    
    /// 아이콘 이미지 뷰
    private lazy var titleImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 옵션 제목
    private lazy var titleUILabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(size: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add SubViews
    private func addSubviews() {
        addSubview(titleImageView)
        addSubview(titleUILabel)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        titleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(titleImageView.snp.height)
        }
        
        titleUILabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleImageView.snp.centerY)
            make.leading.equalTo(titleImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            
        }
    }
    
    /// Input Data
    /// - Parameters:
    ///   - image: 아이콘 이미지
    ///   - title: 제목
    func inputData(image: String, title: String) {
        titleImageView.image = UIImage(named: image)
        titleUILabel.text = title
    }
}
