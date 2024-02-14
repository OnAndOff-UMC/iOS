//
//  CalendarCell.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/18/24.
//

import Foundation
import FSCalendar
import SnapKit
import UIKit

/// 달력 Custom Cell
final class CalendarCell: FSCalendarCell {
    
    /// 동그라미 뒷 배경
    private lazy var backGroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    /// 회고 단계에 따른 색칠되는 비율
    private lazy var percentUIView: RateFillView = {
        let view = RateFillView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Init
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    
    /// Add Subviews
    private func addSubViews() {
        contentView.insertSubview(backGroundUIView, at: 0)
        backGroundUIView.addSubview(percentUIView)
        
        constraints()
    }
    
    /// Set Constraints
    private func constraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backGroundUIView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(frame.height - 10)
            make.width.equalTo(frame.width - 10)
        }
        
        
        percentUIView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(frame.height - 10)
            make.width.equalTo(frame.width - 10)
        }
        
        backGroundUIView.layer.cornerRadius = (frame.height - 10)/2
        percentUIView.layer.cornerRadius = (frame.height - 10)/2
    }
    
    
    /// Input Data
    /// - Parameter data: CalendarStatistics Data
    func inputData(data: CalendarStatistics) {
        if let rate = data.rate {
            percentUIView.setPercent(rate)
        }
    }
}
