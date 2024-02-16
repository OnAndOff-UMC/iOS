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
        let questionId: Int
        let answer: String?
    }
}

/// BookMark Response
struct BookMarkListResponse: Codable {
    let memoirList: [Memoir]
    let pageNumber: Int
    let pageSize: Int
    let totalPages: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

struct Memoir: Codable {
    let date: String?
    let emoticonUrl: String?
    let remain: Int?
}

/// 북마크수정용
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
