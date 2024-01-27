//
//  OffUIView.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/27/24.
//

import Foundation
import SnapKit
import UIKit

/// Off 상태일 때 표시되는 UIView
final class OffUIView: UIView {
    
    /// ScrollView
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 25
        return view
    }()
    
    /// contentView
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Add View
    private func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        constraints()
    }
    
    ///  Constraints
    private func constraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
    }
}
