//
//  Memoirs.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import Foundation

struct MemoirRequest: Codable {
    let date: String
    let emoticonId: Int
    var memoirAnswerList: [MemoirAnswer]

    struct MemoirAnswer: Codable {
        let questionId: Int
        let answer: String?
    }
}

struct MemoirRevisedRequest: Codable {
    let emoticonId: Int
    var memoirAnswerList: [MemoirAnswer]

    struct MemoirAnswer: Codable {
        let answerId: Int
        let answer: String?
    }
}
//
//struct MemoirResponse: Codable {
//    let isSuccess: Bool
//    let code: String
//    let message: String
//    let result: MemoirResult
//
//    struct MemoirResult: Codable {
//        let memoirId: Int?
//        let date: String?
//        let emoticonUrl: String?
//        let isBookmarked: Bool?
//        var memoirAnswerList: [MemoirAnswerDetail]
//
//        struct MemoirAnswerDetail: Codable {
//            let answerId: Int?
//            let question: String?
//            let summary: String?
//            let answer: String?
//        }
//    }
//}

//북마크용
struct MemoirResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MemoirResult

    struct MemoirResult: Codable {
        let memoirId: Int?
        let date: String?
        let emoticonUrl: String?
        let isBookmarked: Bool?
        var memoirAnswerList: [MemoirAnswerDetail]

        struct MemoirAnswerDetail: Codable {
            let questionId: Int?
            let question: String?
            let summary: String?
            let answer: String?
        }
    }
}
