//
//  TabItem.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/27/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum TabItem: Int, CaseIterable {
    case statistics
    case home
    case my
    //탭 안 눌렀을 때의 이미지
    var normalImage: UIImage? {
        switch self {
        case .statistics:
            return UIImage(named: "statisticsuntapped")
        case .home:
            return UIImage(named: "homeuntapped")
        case .my:
            return UIImage(named: "mypageuntapped")
        }
    }
    //탭 눌렀을 때의 이미지
    var selectedImage: UIImage? {
        switch self {
        case .statistics:
            return UIImage(named: "statisticstapped")
        case .home:
            return UIImage(named: "hometapped")
        case .my:
            return UIImage(named: "mypagetapped")
        }
    }
}
