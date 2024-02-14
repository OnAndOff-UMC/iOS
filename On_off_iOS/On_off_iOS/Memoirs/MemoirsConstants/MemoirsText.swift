//
//  MemoirsText.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/28.
//

import Foundation

/// 회고록의 인삿말
struct MemoirsText {
    enum TextType {
        
        /// custom backButton
        case backButton
        
        /// 회고록 보는 페이지
        case learnedToday
        case praiseToday
        case improveFuture
        
        case encouragement
        case dailyReflection
        case praise
        case selfPraisePrompt
        case difficultyPrompt
        case improvementPrompt
        case iconSelection
        case memorialCompleted
    }
    
    /// 회고록의 인삿말
    /// - Parameter type: TextType
    /// - Returns: String
    static func getText(for type: TextType) -> String {
        
        switch type {
        case .backButton:
            return "〈 뒤로가기"
            
        case .learnedToday:
            return "오늘 배운 점"
        case .praiseToday:
            return "오늘 칭찬할 점"
        case .improveFuture:
            return "앞으로 개선할 점"
            
        case .encouragement:
            return "오늘 하루도 수고했어요\n회고로 이제 일에서 완전히 OFF 하세요"

        case .dailyReflection:
            return "오늘 어떤 일을 했나요? 배운 게 있나요?"
        case .praise:
            return "고생했어요"
        case .selfPraisePrompt:
            return "스스로에게 칭찬 한 마디를 쓴다면?"
        case .difficultyPrompt:
            return "어려웠다거나 아쉬운 것도 있나요?"
        case .improvementPrompt:
            return "다음엔 더 잘할 수 있을거예요"
        case .iconSelection:
            return "오늘을 표현할 수 있는 아이콘을 골라주세요\n오늘의 감정이나 인상적인 일을 떠올려보세요"
        case .memorialCompleted:
            return "오늘도 퇴근 완료!\n이제 퇴근 후 일상을 즐겨보세요"
     
        }
    }
}
