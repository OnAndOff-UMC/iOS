//
//  Ext + UIColor.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/30/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >>  8) & 0xFF) / 255.0
        let b = CGFloat((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static func colorFromString(_ string: String) -> UIColor {
        switch string.uppercased() {
        case "YELLOW":
            return UIColor.OnOffYellow
        case "PURPLE":
            return UIColor.OnOffPurple
        case "BLACK":
            return UIColor.black
        case "WHITE":
            return UIColor.white
        default:
            return .clear
        }
    }
}

extension UIColor {
    static let OnOffMain = UIColor(hex: "7D4BFF") // OnOff 메인컬러
    static let OnOffYellow = UIColor(hex: "#FFD572")
    static let OnOffLightMain = UIColor(hex: "#FCF8FF")
    
    //StatisticsView 그래프 컬러
    static let OnOffPurple = UIColor(hex: "#7D4BFF")
    static let backGround = UIColor(hex: "#F8F5FF")
    static let gradient1 = UIColor(hex: "#B297FE")
    static var OnOffLightPurple: UIColor { //날짜 선택 안되었을 때의 컬러
        return OnOffPurple.withAlphaComponent(0.1)
    }
}

