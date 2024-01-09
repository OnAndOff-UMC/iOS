//
//  Color+Ex.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/10/24.
//

import Foundation
import UIKit

extension UIColor {
    static var dateunpick: UIColor {
        return UIColor(hex: 0xB9BCFF)
    }

    static var datepick: UIColor {
        return UIColor(hex: 0x8086FF)
    }

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
