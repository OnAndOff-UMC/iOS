//
//  DateCustomView.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/19/24.
//

import Foundation
import UIKit
import SnapKit

final class DateCustomView: UIView, UICollectionView {
    
    private lazy var dateView: UICollectionView = {
        let view = UICollectionView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.backgroundColor = .dateunpick
        
        //view 조건 추가하기
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateView.layer.cornerRadius = dateView.frame.height/2
        
    }

}
