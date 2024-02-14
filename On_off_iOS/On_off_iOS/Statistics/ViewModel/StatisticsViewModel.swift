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
    private let service = StatisticsService()
    
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
        
        /// 오늘 날짜
        var todayDateRelay: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    }
    
    /// Create Output
    func createoutput(input: Input) -> Output {
        let output = Output()
        
        bindPrevButtonEvents(input: input, output: output)
        bindNextButtonEvents(input: input, output: output)
        getWeekArchieve(output: output)
        getMonthArchieve(output: output)
        return output
    }
    
    /// Bind Prev Button Events
    private func bindPrevButtonEvents(input: Input, output: Output) {
        input.prevButtonEvents?
            .bind { [weak self] in
                guard let self = self else { return }
                output.moveMonthRelay.onNext(-1)
                getPrevMonthArchieve(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Next Button Events
    private func bindNextButtonEvents(input: Input, output: Output) {
        input.nextButtonEvents?
            .bind { [weak self] in
                guard let self = self else { return }
                output.moveMonthRelay.onNext(1)
                getNextMonthArchieve(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// 일주일 비율
    private func inputWeekArchieveRate(result: WeekStatistics, output: Output) {
        output.weekStatisticsRelay.accept(result.weekStatsDTO)
        output.todayDateRelay.accept(result.today)
        if let splitToday = result.today?.split(separator: "-"), let weekOfMonth = result.weekOfMonth {
            output.weekTitleRelay.accept("\(splitToday[0])년 \(weekOfMonth)주차 회고달성률")
            return
        }
        output.weekTitleRelay.accept("")
    }
    
    /// 한달치 낮, 밤 통계
    private func inputMonthArchieveRate(result: WeekStatistics, output: Output) {
        output.todayDateRelay.accept(result.today)
        if let onRate = result.on, let offRate = result.off {
            output.monthStatisticsRelay.accept(MonthStatistics(dayTime: onRate, nightTime: offRate))
        }
        if let splitToday = result.today?.split(separator: "-") {
            output.monthTitleRelay.accept("\(splitToday[0])년 \(splitToday[1])월")
            return
        }
        output.monthTitleRelay.accept("")
    }
    
    /// 회고 작성 비율 데이터
    private func monthWriteRate(result: MonthArchive, output: Output) {
        let title = "이번달 평균 회고 작성률은 PERCENT%"
            .replacingOccurrences(of: "PERCENT", with: "\(result.avg ?? 0)")
        let subTitle = "\n조금만 더 힘내볼까요?✨"
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20),
                                      range: (title as NSString).range(of: title))
        
        attributedString.append(NSMutableAttributedString(string: subTitle))
        output.writeRateRelay.accept(attributedString)
    }
    
    /// 캘린더 더미 데이터
    private func getCalendarList(result: MonthArchive, output: Output) {
        output.calendarListRelay.accept(result.monthStatsList ?? [])
    }
    
    /// 일주일 수치 가져오기
    private func getWeekArchieve(output: Output) {
        service.getWeekAchieveRate()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                inputWeekArchieveRate(result: result, output: output)
                inputMonthArchieveRate(result: result, output: output)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 한달 치 수치 가져오기
    private func getMonthArchieve(output: Output) {
        service.getMonthAchieveRate()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                monthWriteRate(result: result, output: output)
                getCalendarList(result: result, output: output)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 이전달 성공 비율
    private func getPrevMonthArchieve(output: Output) {
        service.getPrevMonthAchieveRate(date: output.todayDateRelay.value ?? "")
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                getCalendarList(result: result, output: output)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 다음달 성공 비율
    private func getNextMonthArchieve(output: Output) {
        service.getNextMonthAchieveRate(date: output.todayDateRelay.value ?? "")
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                getCalendarList(result: result, output: output)
            }, onError: { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
