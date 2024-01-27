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
    
    /// 오늘의 회고 제목 버튼
    private lazy var todayMemoirsLabel: UIButton = {
        let button = UIButton()
        button.setTitle("오늘의 회고", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
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
        contentView.addSubview(todayMemoirsLabel)
        
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
        
        todayMemoirsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
    }
}


import SwiftUI
struct VCPreViewHomeViewController:PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview().previewDevice("iPhone 15 Pro")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}

struct VCPreViewHomeViewController2:PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview().previewDevice("iPhone SE (3rd generation)")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}
