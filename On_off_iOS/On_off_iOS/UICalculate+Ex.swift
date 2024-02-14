//
//  UICalculate+Ex.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/28.
//

import Foundation

///UI고정된 계산값
struct UICalculator {

    enum CalculationType {
        case shortButtonCornerRadius
        case longButtonCornerRadius
    }

    static func calculate(for type: CalculationType, width: CGFloat) -> CGFloat {
        switch type {
        case .shortButtonCornerRadius:
            return width * 0.8 * 0.15 * 0.5
            
        case .longButtonCornerRadius:
            return width * 0.3 * 0.25 * 0.5
        
        }
        
    }
}
