//
//  MemoirsProtocol.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import Foundation
import RxSwift

protocol MemoirsProtocol {
    
    ///  회고록 저장할때
    /// - Parameter request: 서버에 보내는 회고록  정보
    /// - Returns: MemoirResponse
    func saveMemoirs(request: MemoirRequest) -> Observable<MemoirResponse>
    func getEmoticon() -> RxSwift.Observable<EmoticonResponse>
}
