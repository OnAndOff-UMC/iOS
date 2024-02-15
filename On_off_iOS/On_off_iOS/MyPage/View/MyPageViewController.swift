//
//  MyPageViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/15/24.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

final class MyPageViewController: UIViewController {
    
    /// 닉네임 라벨
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "조디 님"
        label.backgroundColor = .clear
        label.textColor = UIColor(hex: "#BDBDBD")
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    /// 업무분야, 경력 라벨
    private lazy var fieldOfWorkAndExperienceYearLabel: UILabel = {
        let label = UILabel()
        label.text = "업무분야 | 연찬"
        label.backgroundColor = .clear
        label.textColor = .OnOffPurple
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    /// Top UIView
    private lazy var topUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// Book Mark Button
    private lazy var bookMarkButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "bookMark", title: "북마크")
        return button
    }()
    
    /// Alert Setting Button
    private lazy var alertSettingButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "alertSetting", title: "알림 설정")
        return button
    }()
    
    /// faq Button
    private lazy var faqButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "faq", title: "FAQ")
        return button
    }()
    
    /// My Info Button
    private lazy var myInfoButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "myInfo", title: "내정보")
        return button
    }()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
    }
    
    /// Add SubViews
    private func addSubViews() {
        view.addSubview(nickNameLabel)
        view.addSubview(fieldOfWorkAndExperienceYearLabel)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        fieldOfWorkAndExperienceYearLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
