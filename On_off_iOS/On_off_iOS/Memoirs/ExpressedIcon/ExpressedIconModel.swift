//
//  ExpressedIconModel.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/28.
//

import Foundation

///이모티콘 정보
struct EmoticonResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [Emoticon]
}

struct Emoticon: Codable {
    let emoticonId: Int
    let imageUrl: String
}
