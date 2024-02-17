//
//  CellIdentifier.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/26/24.
//

import Foundation

/// Cell Indeitifier들 작성!!!!
enum CellIdentifier: String {
    
    // MARK: CollectionViewCell
    case DayCollectionViewCell
    case EmoticonCollectionViewCell

    // MARK: TableViewCell
    case BookmarkTableViewCell
    case ModalSelectProfileTableViewCell // 프로필 설정
    
    // MARK: - Off UIView
    case ImageCollectionView
    case WorkLifeBalanceTableViewCell
    
    // MARK: - On UIView
    case WorkLogTableViewCell
    
    // MARK: - Calendar
    case CalendarCell
    
}
