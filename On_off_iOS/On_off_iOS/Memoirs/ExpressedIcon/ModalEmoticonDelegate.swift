//
//  ModalEmoticonDelegate.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/04.
//

import Foundation

/// 이모티콘 전송 프로토콜
protocol ModalEmoticonDelegate: AnyObject {
    func emoticonSelected(emoticon: Emoticon)
}
