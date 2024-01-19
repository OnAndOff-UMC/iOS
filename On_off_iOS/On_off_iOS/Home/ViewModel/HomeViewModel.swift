//
//  HomeViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/18/24.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    
    struct Output {
        var MainDateRelay: BehaviorRelay<MainDate?> =
        BehaviorRelay(value: nil)
        var MainDayRelay:
        BehaviorRelay<MainDay?> =
        BehaviorRelay(value: nil)
    }
    
    func createoutput() -> Output {
        let output = Output()
        
        dateDummy(output: output)
        dayDummy(output: output)
        return output
    }
    
    private func dateDummy(output: Output) {
        output.MainDateRelay.accept(MainDate(date1: "Mon", date2: "Tue", date3: "Wed", date4: "Thu", date5: "Fri", date6: "Sat", date7: "Sun"))
    }
    
    private func dayDummy(output: Output) {
        output.MainDayRelay.accept(MainDay(day1: 18, day2: 19, day3: 20, day4: 21, day5: 22, day6: 23, day7: 24))
        
    }
}
