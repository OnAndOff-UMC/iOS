//
//  OffUIView.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/27/24.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

/// Off 상태일 때 표시되는 UIView
final class OffUIView: UIView {
    
    /// ScrollView
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 25
        return view
    }()
    
    /// contentView
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 오늘의 회고 제목 버튼
    private lazy var todayMemoirsButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘의 회고", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    /// 제목 옆 벡터 아이콘 배경
    private lazy var todayMemoirsLabelBackgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffPurple
        view.alpha = 0.4
        return view
    }()
    
    /// 오늘의 회고 제목 옆 벡터 아이콘 >
    private lazy var todayMemoirsIconImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()
    
    /// 오늘의 회고 작성 했는지 안했는지 확인하는 UIView
    private lazy var todayMemoirsUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffLightMain
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 워라벨 피드 제목
    private lazy var feedTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle("워라벨 피드", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.OnOffMain, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    /// 워라벨 피드 제목 옆 벡터 아이콘 배경
    private lazy var feedlabelBackgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffPurple
        view.alpha = 0.4
        return view
    }()
    
    /// 워라벨 피드 제목 옆 벡터 아이콘 +
    private lazy var feedPlusIconImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()
    
    /// 워라벨 피드 확인하는 UIView
    private lazy var feedUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffLightMain
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Add View
    private func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(todayMemoirsButton)
        contentView.addSubview(todayMemoirsLabelBackgroundUIView)
        todayMemoirsLabelBackgroundUIView.addSubview(todayMemoirsIconImageButton)
        contentView.addSubview(todayMemoirsUIView)
        contentView.addSubview(feedTitleButton)
        contentView.addSubview(feedlabelBackgroundUIView)
        feedlabelBackgroundUIView.addSubview(feedPlusIconImageButton)
        contentView.addSubview(feedUIView)
        
        constraints()
    }
    
    ///  Constraints
    private func constraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
        todayMemoirsButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        todayMemoirsLabelBackgroundUIView.snp.makeConstraints { make in
            make.height.equalTo(todayMemoirsButton.snp.height).multipliedBy(0.5)
            make.leading.equalTo(todayMemoirsButton.snp.trailing).offset(10)
            make.centerY.equalTo(todayMemoirsButton.snp.centerY)
            make.width.equalTo(todayMemoirsLabelBackgroundUIView.snp.height)
        }
        todayMemoirsLabelBackgroundUIView.layoutIfNeeded()
        todayMemoirsLabelBackgroundUIView.layer.cornerRadius = todayMemoirsLabelBackgroundUIView.frame.height * 0.65
        
        todayMemoirsIconImageButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        feedTitleButton.snp.makeConstraints { make in
            make.top.equalTo(todayMemoirsUIView.snp.bottom).offset(20)
            make.leading.equalTo(todayMemoirsButton.snp.leading)
        }
        
        feedlabelBackgroundUIView.snp.makeConstraints { make in
            make.height.equalTo(feedTitleButton.snp.height).multipliedBy(0.5)
            make.leading.equalTo(feedTitleButton.snp.trailing).offset(10)
            make.centerY.equalTo(feedTitleButton.snp.centerY)
            make.width.equalTo(feedlabelBackgroundUIView.snp.height)
        }
        feedlabelBackgroundUIView.layoutIfNeeded()
        feedlabelBackgroundUIView.layer.cornerRadius = feedlabelBackgroundUIView.frame.height * 0.65
        
        feedPlusIconImageButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        todayMemoirsUIView.snp.makeConstraints { make in
            make.top.equalTo(todayMemoirsButton.snp.bottom).offset(10)
            make.leading.equalTo(todayMemoirsButton.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        feedUIView.snp.makeConstraints { make in
            make.top.equalTo(feedTitleButton.snp.bottom).offset(10)
            make.leading.equalTo(feedTitleButton.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
            make.bottom.equalToSuperview()
        }
        
    }

    /// Binding
    private func bind() {
        todayMemoirsIconImageButton.rx.tap
            .bind {
                print("todayMemoirsIconImageButton tapped")
            }
            .disposed(by: disposeBag)
        
        todayMemoirsButton.rx.tap
            .bind {
                print("todayMemoirsButton tapped")
            }
            .disposed(by: disposeBag)
    }
    
}


import SwiftUI
struct VCPreViewHomeViewController:PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview().previewDevice("iPhone 15 Pro")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}

struct VCPreViewHomeViewController2:PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview().previewDevice("iPhone SE (3rd generation)")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}
