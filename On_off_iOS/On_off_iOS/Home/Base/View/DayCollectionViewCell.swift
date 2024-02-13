//
//  DayCollectionViewCell.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/25/24.
//

import Foundation
import SnapKit
import UIKit

final class DayCollectionViewCell: UICollectionViewCell {

    /// 요일 라벨
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    /// 일 라벨
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    /// 일, 요일을 묶는 StackView
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dayLabel, dateLabel])
        view.backgroundColor = .clear
        view.spacing = 10
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    
    /// 동그란 모양을 위한 UIView
    private lazy var cornerUIView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
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
    
    /// Cell Add SubView
    private func addSubViews() {
        addSubview(cornerUIView)
        cornerUIView.addSubview(stackView)
        
        constraints()
    }
    
    /// Cell Constraints
    private func constraints() {
        cornerUIView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    /// Input Data About Day, Date
    /// - Parameter info: DayInfo
    /// - Parameter color: BackGround Color
    /// - Parameter textColor: TextColor
    func inputData(info: DayInfo, color: UIColor, textColor: UIColor) {
        dayLabel.text = info.day ?? ""
        dayLabel.textColor = textColor
        dateLabel.text = info.date ?? ""
        dateLabel.textColor = textColor
        cornerUIView.backgroundColor = color
    }
    
    /// 선택됐을때 효과
    /// - Parameters:
    ///   - color: BackGround Color
    ///   - textColor: Text Color
    func selectedEffect(color: UIColor, textColor: UIColor) {
        cornerUIView.backgroundColor = color
        dayLabel.textColor = textColor
        dateLabel.textColor = textColor
    }
}

