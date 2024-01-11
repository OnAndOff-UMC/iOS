//
//  StatisticsViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/11/24.
//

import Foundation
import RxSwift
import RxRelay

final class StatisticsViewModel {
    
    struct Output {
        var weekStatisticsRelay: BehaviorRelay<DayStatistics?> = BehaviorRelay(value: nil)
        var monthStatisticsRelay: BehaviorRelay<MonthStatistics?> = BehaviorRelay(value: nil)
    }
    
    /// Create Output
    func createoutput() -> Output {
        let output = Output()
        
        weekDummy(output: output)
        monthDummy(output: output)
        return output
    }
    
    /// 일주일 비율 더미
    private func weekDummy(output: Output) {
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
        output.monthStatisticsRelay.accept(MonthStatistics(dayTime: 0.3, nightTime: 0.6))
    }
}
