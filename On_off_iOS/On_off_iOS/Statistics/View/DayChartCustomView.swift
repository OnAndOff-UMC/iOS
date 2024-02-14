//
//  DayChartCustomView.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/11/24.
//

import Foundation
import UIKit
import SnapKit

final class DayChartCustomView: UIView {
    
    /// ON 제목
    private lazy var onTitle: UILabel = {
        let label = UILabel()
        label.text = "ON"
        label.backgroundColor = .clear
        label.font = .pretendard(size: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    /// dayTime ProgressView
    private lazy var dayTimeProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .OnOffPurple
        return view
    }()
    
    /// 햇빛 이미지 담는 뷰
    private lazy var dayTimeUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#9268FF")
        return view
    }()
    
    /// 햇빛 이미지
    private lazy var dayTimeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "sun"))
        view.backgroundColor = .clear
        return view
    }()
    
    /// OFF 제목
    private lazy var offTitle: UILabel = {
        let label = UILabel()
        label.text = "OFF"
        label.backgroundColor = .clear
        label.font = .pretendard(size: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    /// nightTime ProgressView
    private lazy var nightTimeProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .OnOffPurple
        return view
    }()
    
    /// 달 이미지 담는 뷰
    private lazy var nightTimeUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#9268FF")
        return view
    }()
    
    /// 달 이미지
    private lazy var nightTimeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "moon"))
        view.backgroundColor = .clear
        return view
    }()
    
    /// StackView
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dayTimeProgressView, nightTimeProgressView])
        view.backgroundColor = .clear
        view.axis = .vertical
        view.spacing = 60
        view.distribution = .fillEqually
        return view
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Layout SubView
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dayTimeUIView.layer.cornerRadius = dayTimeUIView.frame.height/2
        nightTimeUIView.layer.cornerRadius = nightTimeUIView.frame.height/2
    }
    
    /// AddSubViews
    private func addSubViews() {
        
        addSubview(stackView)
        
        addSubview(dayTimeUIView)
        dayTimeUIView.addSubview(dayTimeImageView)
        
        addSubview(nightTimeUIView)
        nightTimeUIView.addSubview(nightTimeImageView)
        
        addSubview(onTitle)
        addSubview(offTitle)
        
        constraints()
    }
    
    /// Set Constraints
    private func constraints() {
        onTitle.snp.makeConstraints { make in
            make.bottom.equalTo(dayTimeProgressView.snp.top).offset(-5)
            make.leading.equalTo(stackView.snp.leading)
        }
        
        offTitle.snp.makeConstraints { make in
            make.bottom.equalTo(nightTimeProgressView.snp.top).offset(-5)
            make.leading.equalTo(stackView.snp.leading)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        dayTimeProgressView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        dayTimeUIView.snp.makeConstraints { make in
            make.centerY.equalTo(dayTimeProgressView.snp.centerY)
            make.height.width.equalTo(dayTimeProgressView.snp.height).multipliedBy(1.2)
            make.leading.equalTo(100)
        }
        
        dayTimeImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(dayTimeProgressView.snp.height).multipliedBy(0.7)
        }
        
        nightTimeProgressView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        nightTimeUIView.snp.makeConstraints { make in
            make.centerY.equalTo(nightTimeProgressView.snp.centerY)
            make.height.width.equalTo(nightTimeProgressView.snp.height).multipliedBy(1.2)
            make.leading.equalTo(100)
        }
        
        nightTimeImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(nightTimeProgressView.snp.height).multipliedBy(0.7)
        }
    }
    
    /// Remake Constraints
    private func remakeConstraints() {
        dayTimeUIView.snp.remakeConstraints { make in
            make.centerY.equalTo(dayTimeProgressView.snp.centerY)
            make.height.width.equalTo(dayTimeProgressView.snp.height).multipliedBy(1.2)
            make.centerX.equalTo(dayTimeProgressView.snp.leading).offset(dayTimeProgressView.frame.width * CGFloat(dayTimeProgressView.progress))
        }
        
        nightTimeUIView.snp.remakeConstraints { make in
            make.centerY.equalTo(nightTimeProgressView.snp.centerY)
            make.height.width.equalTo(nightTimeProgressView.snp.height).multipliedBy(1.2)
            make.centerX.equalTo(nightTimeProgressView.snp.leading).offset(nightTimeProgressView.frame.width * CGFloat(nightTimeProgressView.progress))
        }
    }
    
    /// Input Data about ProgressView
    /// - Parameter statistics: 낮, 밤 비율 (0.0 ~ 1.0)
    func inputData(statistics: MonthStatistics) {
        dayTimeProgressView.progress = Float(statistics.dayTime ?? 0)
        nightTimeProgressView.progress = Float(statistics.nightTime ?? 0)
        remakeConstraints()
    }
    
}
