//
//  HomeViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/25/24.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        /// 날짜(일) 리스트
        var dayListRelay: BehaviorRelay<[DayInfo]> = BehaviorRelay(value: [])
        
        
    }
    
    /// Create Output
    /// - Parameter input: Input
    /// - Returns: Output
    func createOutput(input: Input) -> Output{
        let output = Output()
        
        dummyDayListRelay(output: output)
        return output
    }
    
    /// dummy about dayListRelay
    private func dummyDayListRelay(output: Output) {
        let list = [DayInfo(date: "20", day: "Mon"),
                    DayInfo(date: "21", day: "Tue"),
                    DayInfo(date: "22", day: "Wed"),
                    DayInfo(date: "23", day: "Thr"),
                    DayInfo(date: "24", day: "Fri"),
                    DayInfo(date: "25", day: "Sat"),
                    DayInfo(date: "26", day: "Sun")]
        output.dayListRelay.accept(list)
    }
}
