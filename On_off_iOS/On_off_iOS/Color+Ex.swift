//
//  Color+Ex.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/1/24.
//

import Foundation
import UIKit

extension UIColor {
    
    static let customPurple = UIColor(hex: 0xA9ADFF) //메인화면 조디
    static let customBlue = UIColor(hex: 0x8086FF) //메인화면 캘린더 선택되었을 때

    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
