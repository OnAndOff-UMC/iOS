//
//  Ext + NSAttributedString.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/06.
//

import UIKit

/// text중 포인드로 줄 단어만 다른 색으로 바꾸기
extension NSAttributedString {
    static func createAttributedText(mainText: String, highlightTexts: [String], attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: mainText)
        
        highlightTexts.forEach { text in
            let range = (mainText as NSString).range(of: text)
            if range.location != NSNotFound {
                attributedString.addAttributes(attributes, range: range)
            }
        }
        
        return attributedString
    }
}

extension OnBoardingViewController {
    func createAttributedText(for text: String, highlightWords: [(String, UIColor, UIFont)]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        highlightWords.forEach { word, color, font in
            let range = (text as NSString).range(of: word)
            if range.location != NSNotFound {
                attributedString.addAttributes([.foregroundColor: color, .font: font], range: range)
            }
        }
        return attributedString
    }
}

