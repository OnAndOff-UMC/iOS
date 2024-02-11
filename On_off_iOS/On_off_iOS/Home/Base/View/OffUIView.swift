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
    
    /// ContentView
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
        button.setTitleColor(.OnOffMain, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
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
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
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
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
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
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
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
    
    /// 날짜 라벨
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023 - November"
        label.backgroundColor = .clear
        label.textColor = .OnOffMain
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    /// 이미지 CollectionView
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ImageCollectionViewCell.self,
                                     forCellWithReuseIdentifier: CellIdentifier.ImageCollectionView.rawValue)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = OffUIViewModel()
    private var heightConstraint: Constraint?
    var clickedImageButton: PublishSubject<Void> = PublishSubject()
    var selectedImage: PublishSubject<UIImage> = PublishSubject()
    
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
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageCollectionView)
        
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
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(feedUIView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            heightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    /// Binding
    private func bind() {
        let output = viewModel.createOutput(input: OffUIViewModel.Input(todayMemoirsButtonEvents: todayMemoirsButton.rx.tap,
                                                                        todayMemoirsIconImageButtonEvents: todayMemoirsIconImageButton.rx.tap,
                                                                        feedTitleButtonEvents: feedTitleButton.rx.tap,
                                                                        feedPlusIconImageButtonEvents: feedPlusIconImageButton.rx.tap,
                                                                        collectionViewCellEvents: imageCollectionView.rx.itemSelected,
                                                                        selectedImage: selectedImage))
        bindCollectionView(output: output)
        bindClickPlusImageButton(output: output)
    }
    
    /// Binding CollectionView
    private func bindCollectionView(output: OffUIViewModel.Output) {
        var count = output.imageURLRelay.value.count - 1
        let width: CGFloat = (self.frame.width - 20 - 10 * 2) / 3
        count = output.imageURLRelay.value.count < 9 ? count : 8
        heightConstraint?.update(offset: CGFloat(count / 3 + 1) * width + CGFloat((count / 3 + 1) * 10))
        
        output.imageURLRelay
            .bind(to: imageCollectionView.rx
                .items(cellIdentifier: CellIdentifier.ImageCollectionView.rawValue,
                       cellType: ImageCollectionViewCell.self))
        { row, element, cell in
            cell.layer.cornerRadius = 20
            
            if element == "plus.circle.fill" {
                cell.layer.borderWidth = 1
                cell.lastData(image: element)
                cell.backgroundColor = .clear
                return
            }
            cell.inputData(imageURL: element)
            cell.backgroundColor = .green
            cell.layer.borderWidth = 0
        }
        .disposed(by: disposeBag)
        
        imageCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// 이미지 추가 버튼 눌렀을 때
    /// 이미지 선택하는 화면으로 이동
    private func bindClickPlusImageButton(output: OffUIViewModel.Output) {
        output.clickPlusImageButton
            .bind { [weak self] in
                guard let self = self else { return }
                print(#function)
                clickedImageButton.onNext(())
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension OffUIView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interval: CGFloat = 10
        let width: CGFloat = (collectionView.frame.width - interval * 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
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
