//
//  ModalSelectProfileDelegate.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/05.
//

import Foundation

/// ModalSelectProfileDelegate: 프로필 모달창에서 메인화면에 데이터 넘기기
protocol ModalSelectProfileDelegate: AnyObject {
    func optionSelected(data: String, dataType: ProfileDataType)
}
