//
//  TestView.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/18/24.
//

import Foundation
import UIKit

/// 성취도에 따른 채우기 View
final class RateFillView: UIView {
    private var percent: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let startAngle: CGFloat = (-(.pi) / 2)
        let endAngle = percent * (.pi * 2)
        
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center,
                    radius: 60,
                    startAngle: startAngle,
                    endAngle: startAngle + endAngle,
                    clockwise: true)
        UIColor.green.set()
        path.fill()
        path.close()
        
        UIColor.lightGray.set()
        if percent == 1.0 {
            UIColor.green.set()
            path.lineWidth = 1
        }

        path.stroke()
    }

    
    /// 회고 작성 비율
    /// - Parameter value: 작성한 회고 %
    func setPercent(_ value: CGFloat) {
         percent = value
         setNeedsDisplay()
     }
    
}
