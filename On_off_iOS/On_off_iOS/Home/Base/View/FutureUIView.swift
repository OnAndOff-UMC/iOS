//
//  FutureUIView.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/13/24.
//

import Foundation
import UIKit

final class FutureUIView: UIView {
    
    /// 제목 라벨
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "미래 날짜로 왔어요"
        label.textColor = .OnOffMain
        label.font = .pretendard(size: 24, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
  
    /// 부제목 라벨
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 해야할 업무를 떠올려보세요!"
        label.textColor = .black
        label.font = .pretendard(size: 16, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 미래 이미지 뷰
    private lazy var futureImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "future"))
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add Sub Views
    private func addSubViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(futureImageView)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        futureImageView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
}
