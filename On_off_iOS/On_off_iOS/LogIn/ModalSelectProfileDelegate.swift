//
//  ModalSelectProfileDelegate.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/05.
//

import Foundation

protocol ModalSelectProfileDelegate: AnyObject {
    func optionSelected(data: String, dataType: ProfileDataType)
}
