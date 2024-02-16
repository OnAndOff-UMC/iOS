//
//  DeletedMemoirsPopUpDelegate.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/16.
//

import Foundation

/// Popup창읭 삭제버튼 클릭후 이전화면으로 이동
protocol DeletedMemoirsPopUpDelegate: AnyObject {
    func didDeleteMemoirSuccessfully()
}

