//
//  TodayResolutionViewModel.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/2/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class TodayResolutionViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
//        let onOffButtonEvents: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func createOutput(input: Input) -> Output{
        let output = Output()
        return output
    }
    
}
