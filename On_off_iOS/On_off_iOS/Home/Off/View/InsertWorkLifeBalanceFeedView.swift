//
//  InsertWorkLifeBalanceFeed.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/12/24.
//

import Foundation
import SnapKit
import RxSwift
import UIKit

/// 워라벨 피드 입력
final class InsertWorkLifeBalanceFeedView: DimmedViewController {
    
    /// 배경 뷰
    private lazy var baseUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    // MARK: - Init
    init() {
        super.init(durationTime: 0.3, alpha: 0.7)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add Subviews
    private func addSubviews() {
        view.addSubview(baseUIView)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        baseUIView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
