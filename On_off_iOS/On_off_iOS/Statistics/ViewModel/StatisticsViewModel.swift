//
//  StatisticsViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/11/24.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
import UIKit

final class StatisticsViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let prevButtonEvents: ControlEvent<Void>?
        let nextButtonEvents: ControlEvent<Void>?
    }
    
    struct Output {
        /// 달 제목
        var monthTitleRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        
        /// 햇빛, 달 통계
        var monthStatisticsRelay: BehaviorRelay<MonthStatistics?> = BehaviorRelay(value: nil)
        
        /// 몇 주차 제목
        var weekTitleRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
        
        /// 주차 별 통계 (막대 그래프)
        var weekStatisticsRelay: BehaviorRelay<DayStatistics?> = BehaviorRelay(value: nil)
        
        /// 회고 작성 비율
        var writeRateRelay: BehaviorRelay<NSMutableAttributedString?> = BehaviorRelay(value: nil)
        
        /// 달 옮기는 Relay
        var moveMonthRelay: BehaviorSubject<Int> = BehaviorSubject(value: 0)
        
        /// 캘린더 작성 비율
        var calendarListRelay: BehaviorRelay<[CalendarStatistics]> = BehaviorRelay(value: [])
    }
    
    /// Create Output
    func createoutput(input: Input) -> Output {
        let output = Output()
        
        input.prevButtonEvents?
            .bind {
                output.moveMonthRelay.onNext(-1)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonEvents?
            .bind {
                output.moveMonthRelay.onNext(1)
            }
            .disposed(by: disposeBag)
        
        weekDummy(output: output)
        monthDummy(output: output)
        writeRateDummy(output: output)
        dummyCalendar(output: output)
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
    
    /// 한달치 낮, 밤 통계
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
    
    /// 캘린더 더미 데이터
    private func dummyCalendar(output: Output) {
        let list = [
            CalendarStatistics(date: "2024-01-24", rate: 0.25),
            CalendarStatistics(date: "2024-01-02", rate: 0.5),
            CalendarStatistics(date: "2024-01-04", rate: 0.75),
            CalendarStatistics(date: "2024-01-10", rate: 1),
            CalendarStatistics(date: "2024-01-14", rate: 0.5),
            CalendarStatistics(date: "2024-01-24", rate: 0.25),
        ]
        
        output.calendarListRelay.accept(list)
    }
}
