//
//  StatisticsViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/11/24.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

final class StatisticsViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        var monthTitleRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var monthStatisticsRelay: BehaviorRelay<MonthStatistics?> = BehaviorRelay(value: nil)
        var weekTitleRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        var weekStatisticsRelay: BehaviorRelay<DayStatistics?> = BehaviorRelay(value: nil)
        var writeRateRelay: BehaviorRelay<NSMutableAttributedString?> = BehaviorRelay(value: nil)
    }
    
    /// Create Output
    func createoutput() -> Output {
        let output = Output()
        
        weekDummy(output: output)
        monthDummy(output: output)
        writeRateDummy(output: output)
        return output
    }
    
    /// 일주일 비율 더미
    private func weekDummy(output: Output) {
        output.weekTitleRelay.accept("11월 3주차")
        output.weekStatisticsRelay.accept(DayStatistics(monday: 0.4,
                                                        tuesday: 0.7,
                                                        wendseday: 0.2,
                                                        thursday: 0.9,
                                                        friday: 0.6,
                                                        saturday: 0.5,
                                                        sunday: 0.2))
    }
    
    /// 한달치 낮,밤 통계 
    private func monthDummy(output: Output) {
        output.monthTitleRelay.accept("2023년 11월")
        output.monthStatisticsRelay.accept(MonthStatistics(dayTime: 0.3, nightTime: 0.6))
    }
    
    /// 회고 작성 비율 더미 데이터
    private func writeRateDummy(output: Output) {
        let title = "이번달 평균 회고 작성률은 PERCENT%"
            .replacingOccurrences(of: "PERCENT", with: "50")
        let subTitle = "\n조금만 더 힘내볼까요?✨"
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20),
                                      range: (title as NSString).range(of: title))
        
        attributedString.append(NSMutableAttributedString(string: subTitle))
        
        output.writeRateRelay.accept(attributedString)
    }
}
