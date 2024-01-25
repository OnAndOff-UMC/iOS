//
//  HomeViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/25/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import UIKit

final class HomeViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let onOffButtonEvents: ControlEvent<Void>
        
    }
    
    struct Output {
        /// On-Off 에 따른 Button Image
        ///  on or off
        var buttonOnOffRelay: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
        
        /// Title(제목) Relay
        var titleRelay: BehaviorRelay<NSMutableAttributedString?> = BehaviorRelay(value: nil)
        
        /// On-Off 에 따른 Title Image
        ///  moon or sun
        var dayImageRelay: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
        
        /// 현재 달, 연도
        var monthRelay: BehaviorRelay<NSMutableAttributedString?> = BehaviorRelay(value: nil)
        
        /// 날짜(일) 리스트
        var dayListRelay: BehaviorRelay<[DayInfo]> = BehaviorRelay(value: [])
        
        /// 전체 View 배경 색
        var backgroundColorRelay: BehaviorRelay<UIColor> = BehaviorRelay(value: UIColor.white)
        
        /// Day Collection 배경 색
        var dayCollectionViewBackgroundColorRelay: BehaviorRelay<UIColor> = BehaviorRelay(value: UIColor.cyan)
        
        /// On-Off 변하는 UIView그림자 색
        var blankUIViewShadowColorRelay: BehaviorRelay<UIColor> = BehaviorRelay(value: UIColor.purple)
        
        /// On Off 버튼 터치에 따른 값 변환
        /// true: On
        /// false: Off
        var toggleOnOffButtonRelay: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        
    }
    
    /// Create Output
    /// - Parameter input: Input
    /// - Returns: Output
    func createOutput(input: Input) -> Output{
        let output = Output()
        
        input.onOffButtonEvents
            .bind {
                output.toggleOnOffButtonRelay.accept(!output.toggleOnOffButtonRelay.value)
            }
            .disposed(by: disposeBag)
        
        bindToggleOnOffButtonRelay(output: output)
        dummyDayListRelay(output: output)
        return output
    }
    
    /// Bind Toggle When OnOffButton Touches
    private func bindToggleOnOffButtonRelay(output: Output) {
        output.toggleOnOffButtonRelay
            .bind { [weak self] check in
                guard let self = self else { return }
                
                if check { // On 인경우
                    setUpWhenOn(output: output)
                    return
                }
                
                // Off인 경우
                setUpWhenOff(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Setting When On
    private func setUpWhenOn(output: Output) {
        output.dayImageRelay.accept(UIImage(named: "sun"))
        output.buttonOnOffRelay.accept(UIImage(named: "on"))
        output.backgroundColorRelay.accept(.white)
        output.titleRelay.accept(setTitleOptions(nickName: "조디조디조디조디조디", nickNameColor: .purple,
                                                 subTitle: "님,\n오늘 하루도 파이팅!", subTitleColor: .black,
                                                 output: output))
        output.monthRelay.accept(setMonthOptions(month: "2023년 11월",
                                                 monthColor: .purple,
                                                 output: output))
        output.dayCollectionViewBackgroundColorRelay.accept(.cyan)
        output.blankUIViewShadowColorRelay.accept(.purple)
    }
    
    /// Setting When Off
    private func setUpWhenOff(output: Output) {
        output.dayImageRelay.accept(UIImage(named: "moon"))
        output.buttonOnOffRelay.accept(UIImage(named: "off"))
        output.backgroundColorRelay.accept(.blue)
        output.titleRelay.accept(setTitleOptions(nickName: "조디조디조디조디조디", nickNameColor: .yellow,
                                                 subTitle:  "님,\n오늘 하루도 고생하셨어요", subTitleColor: .white,
                                                 output: output))
        output.monthRelay.accept(setMonthOptions(month: "2023년 11월",
                                                 monthColor: .white,
                                                 output: output))
        output.dayCollectionViewBackgroundColorRelay.accept(.purple)
        output.blankUIViewShadowColorRelay.accept(.white)
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
    
    
    /// Month Label On Off에 따라 설정 변경
    /// - Parameters:
    ///   - month: Month
    ///   - monthColor: Month Color
    ///   - output: Output
    /// - Returns: 변경된 NSMutableAttributedString
    private func setMonthOptions(month: String,
                                 monthColor: UIColor,
                                 output: Output) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: month)
        attributedString.addAttribute(.foregroundColor, value: monthColor,
                                      range: (month as NSString).range(of: month))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .bold),
                                      range: (month as NSString).range(of: month))
        return attributedString
    }
    
    
    /// Title Label On Off에 따라 설정 변경
    /// - Parameters:
    ///   - nickName: 사용자 NickName
    ///   - nickNameColor: NickName Color
    ///   - subTitle: NickName 뒤에 쓰는 붙임 말
    ///   - subTitleColor: SubTitle Color
    ///   - output: Output
    /// - Returns: 변경된 NSMutableAttributedString
    private func setTitleOptions(nickName: String,
                                 nickNameColor: UIColor,
                                 subTitle: String,
                                 subTitleColor: UIColor,
                                 output: Output) -> NSMutableAttributedString {
        let nickNameAttributedString = NSMutableAttributedString(string: nickName)
        nickNameAttributedString.addAttribute(.foregroundColor, value: nickNameColor,
                                      range: (nickName as NSString).range(of: nickName))
        nickNameAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .bold),
                                      range: (nickName as NSString).range(of: nickName))
        
        let subTitleAttributedString = NSMutableAttributedString(string: subTitle)
        subTitleAttributedString.addAttribute(.foregroundColor, value: subTitleColor,
                                      range: (subTitle as NSString).range(of: subTitle))
        subTitleAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .bold),
                                      range: (subTitle as NSString).range(of: subTitle))
        
        nickNameAttributedString.append(subTitleAttributedString)
        return nickNameAttributedString
    }
    
    
}
