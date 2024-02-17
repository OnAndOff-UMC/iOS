//
//  EmoticonSelectionDelegate.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/04.
//

import Foundation

/// EmoticonSelectionDelegate
protocol EmoticonSelectionDelegate: AnyObject {
    func emoticonSelected(emoticonId: Int, imageUrl: String)
}

