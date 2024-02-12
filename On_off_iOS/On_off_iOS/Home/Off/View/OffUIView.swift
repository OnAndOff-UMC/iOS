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
    private lazy var feedUITableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .OnOffLightMain
        view.layer.cornerRadius = 20
        view.register(WorkLifeBalanceTableViewCell.self,
                      forCellReuseIdentifier: CellIdentifier.WorkLifeBalanceTableViewCell.rawValue)
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
    
    /// 이미지 추가 버튼 누른 경우
    var clickedImagePlusButton: PublishSubject<Void> = PublishSubject()
    
    /// 앨범에서 선택한 이미지 전송
    var selectedImage: PublishSubject<UIImage> = PublishSubject()
    
    /// 이미지 선택한경우
    var clickedImageButton: PublishSubject<Image?> = PublishSubject()
    
    var clickedAddfeedButton: PublishSubject<Void> = PublishSubject()
    
    /// 선택한 날짜
    
    var selectedDate: PublishSubject<String> = PublishSubject()
    private var successDeleteImage: PublishSubject<Void> = PublishSubject()
    var successAddFeed: PublishSubject<Void> = PublishSubject()
    private var loadWLBFeed: PublishSubject<Void> = PublishSubject()
    private var clickCheckMarkOfWLBFeed: PublishSubject<Feed> = PublishSubject()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        print(#function)
        successDeleteImage.onNext(())
        loadWLBFeed.onNext(())
    }
    
    /// Add View
    private func addSubViews(output: OffUIViewModel.Output) {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(todayMemoirsButton)
        contentView.addSubview(todayMemoirsLabelBackgroundUIView)
        todayMemoirsLabelBackgroundUIView.addSubview(todayMemoirsIconImageButton)
        contentView.addSubview(todayMemoirsUIView)
        contentView.addSubview(feedTitleButton)
        contentView.addSubview(feedlabelBackgroundUIView)
        feedlabelBackgroundUIView.addSubview(feedPlusIconImageButton)
        contentView.addSubview(feedUITableView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageCollectionView)
        
        constraints(output: output)
    }
    
    ///  Constraints
    private func constraints(output: OffUIViewModel.Output) {
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
        
        feedUITableView.snp.makeConstraints { make in
            make.top.equalTo(feedTitleButton.snp.bottom).offset(10)
            make.leading.equalTo(feedTitleButton.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            output.tableViewHeightConstraint.accept(make.height.equalTo(200).constraint)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(feedUITableView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            output.collectionViewHeightConstraint.accept(make.height.equalTo(0).constraint)
        }
    }
    
    /// Binding
    private func bind() {
        let output = viewModel.createOutput(input: OffUIViewModel.Input(todayMemoirsButtonEvents: todayMemoirsButton.rx.tap,
                                                                        todayMemoirsIconImageButtonEvents: todayMemoirsIconImageButton.rx.tap,
                                                                        collectionViewCellEvents: imageCollectionView.rx.itemSelected,
                                                                        selectedImage: selectedImage,
                                                                        successDeleteImage: successDeleteImage, 
                                                                        loadWLBFeed: loadWLBFeed,
                                                                        clickCheckMarkOfWLBFeed: clickCheckMarkOfWLBFeed,
                                                                        selectedDate: selectedDate,
                                                                        successAddFeed: successAddFeed))
        addSubViews(output: output)
        bindCollectionView(output: output)
        bindTableView(output: output)
        bindClickPlusImageButton(output: output)
        bindClickImageButton(output: output)
        bindFeedEvents()
    }
    
    /// 워라벨 피드 제목 버튼 및 이미지 버튼
    private func bindFeedEvents() {
        feedTitleButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                clickedAddfeedButton.onNext(())
            }
            .disposed(by: disposeBag)
        
        feedPlusIconImageButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                clickedAddfeedButton.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Work Life Balance Table View
    private func bindTableView(output: OffUIViewModel.Output) {
        output.workLifeBalanceRelay
            .bind { list in
                if list.count > 4 {
                    output.tableViewHeightConstraint.value?.update(offset: 200 + (50 * (list.count - 4)))
                    return
                }
                output.tableViewHeightConstraint.value?.update(offset: 200)
            }
            .disposed(by: disposeBag)
        
        output.workLifeBalanceRelay
            .bind(to: feedUITableView.rx.items(cellIdentifier: CellIdentifier.WorkLifeBalanceTableViewCell.rawValue,
                                               cellType: WorkLifeBalanceTableViewCell.self))
        { [weak self] row, element, cell in
            guard let self = self else { return }
            cell.inputData(feed: element)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.checkMarkButtonEvents
                .bind { [weak self] in
                    guard let self = self else { return }
                    clickCheckMarkOfWLBFeed.onNext(element)
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        feedUITableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// Binding CollectionView
    private func bindCollectionView(output: OffUIViewModel.Output) {
        output.imageURLRelay
            .bind { list in
                var count = list.count - 1
                count = list.count < 9 ? count : 8
                let width: CGFloat = (self.frame.width - 20 - 10 * 2) / 3
                output.collectionViewHeightConstraint.value?.update(offset: CGFloat(count / 3 + 1) * width + CGFloat((count / 3 + 1) * 10))
            }
            .disposed(by: disposeBag)
        
        output.imageURLRelay
            .bind(to: imageCollectionView.rx
                .items(cellIdentifier: CellIdentifier.ImageCollectionView.rawValue,
                       cellType: ImageCollectionViewCell.self))
        { row, element, cell in
            cell.layer.cornerRadius = 20
            
            if element.imageUrl == "plus.circle.fill" {
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.OnOffMain.cgColor
                cell.lastData(image: element)
                cell.backgroundColor = .clear
                return
            }
            cell.inputData(image: element)
            cell.backgroundColor = .clear
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
                clickedImagePlusButton.onNext(())
            }
            .disposed(by: disposeBag)
        
    }
    
    /// 이미지 선택했을 때
    /// 이미지 크게 보는 화면으로 이동
    private func bindClickImageButton(output: OffUIViewModel.Output) {
        output.selectedImageRelay
            .bind { [weak self] imageURL in
                guard let self = self else { return }
                clickedImageButton.onNext(imageURL)
            }
            .disposed(by: disposeBag)
    }
}

extension OffUIView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
