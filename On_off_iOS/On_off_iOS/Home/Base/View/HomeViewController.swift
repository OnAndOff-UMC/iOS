//
//  HomeViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/25/24.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    
    /// Safe Area Top Layout UIView
    private lazy var safeAreaTopUIView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// On - Off Button
    private lazy var onOffButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    /// Title Label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 24)
        label.backgroundColor = .clear
        return label
    }()
    
    /// On - Off 에 따른 이미지 뷰
    private lazy var dayImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        return view
    }()
    
    /// 현재 달, 연도
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .purple
        label.backgroundColor = .clear
        return label
    }()
    
    /// "일" 스크롤 뷰
    private lazy var dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier.DayCollectionViewCell.rawValue)
        return view
    }()
    
    /// Off UIViewr
    private lazy var offUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 25
        
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowOpacity = 0.5
        
        return view
    }()
    
    /// On UIView
    private lazy var onUIView: OnUIView = {
        let view = OnUIView(frame: CGRect(x: .zero, y: .zero, width: view.safeAreaLayoutGuide.layoutFrame.width, height: .zero))
        view.backgroundColor = .white
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 25
        
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowOpacity = 0.5
        
        return view
    }()
    
    
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBaseSubViews()
        bind()
        print("\(OnUIView.self) 화면에 좀 떠주라...제발...나 시간이 없어...")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        offUIView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0,
                                                              width: offUIView.frame.width,
                                                              height: offUIView.frame.height - 50)).cgPath
        
    }
    
    /// Off  UI Add View
    private func addOffSubViews() {
        view.addSubview(offUIView)
        
        offConstraints()
    }
    
    /// Off UI Constraints
    private func offConstraints() {
        offUIView.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// On  UI Add View
    private func addOnSubViews() {
        view.addSubview(onUIView)
        
        onConstraints()
    }
    
    /// On UI Constraints
    private func onConstraints() {
        onUIView.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// On - Off 공통 UI Add View
    private func addBaseSubViews() {
        view.addSubview(safeAreaTopUIView)
        view.addSubview(onOffButton)
        view.addSubview(titleLabel)
        view.addSubview(dayImageView)
        view.addSubview(monthLabel)
        view.addSubview(dayCollectionView)
        
        baseConstraints()
    }
    
    /// On - Off 공통 UI Constraints
    private func baseConstraints() {
        onOffButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        safeAreaTopUIView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(onOffButton.snp.top)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(onOffButton.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        dayImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalTo(titleLabel.snp.trailing).offset(30)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-6)
            make.height.equalTo(70)
        }
    }
    
    /// Binding
    private func bind() {
        let input = HomeViewModel.Input(onOffButtonEvents: onOffButton.rx.tap)
        let output = viewModel.createOutput(input: input)
        
        bindDayCollectionView(output: output)
        bindMonthLabel(output: output)
        bindTitleLabel(output: output)
        bindDayImageView(output: output)
        bindOnOffButton(output: output)
        bindBackGroundColor(output: output)
        bindBlankViewShadowColor(output: output)
        bindToggleOnOffButton(output: output)
        bindAddWorkLogButton()
        bindSelectedFeedTableViewCell()
        
        
    }
    
    /// Binding Day CollectionView Cell
    private func bindDayCollectionView(output: HomeViewModel.Output) {
        output.dayListRelay
            .bind(to: dayCollectionView.rx
                .items(cellIdentifier: CellIdentifier.DayCollectionViewCell.rawValue,
                       cellType: DayCollectionViewCell.self))
        { row, element, cell in
            cell.backgroundColor = .clear
            cell.inputData(info: element, color: output.dayCollectionViewBackgroundColorRelay.value)
        }
        .disposed(by: disposeBag)
        
        dayCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// Binding Month Label
    private func bindMonthLabel(output: HomeViewModel.Output) {
        output.monthRelay
            .bind { [weak self] month in
                guard let self = self else { return }
                monthLabel.attributedText = month
                dayCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Title Label
    private func bindTitleLabel(output: HomeViewModel.Output) {
        output.titleRelay
            .bind { [weak self] title in
                guard let self = self else { return }
                titleLabel.attributedText = title
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Day Image View
    private func bindDayImageView(output: HomeViewModel.Output) {
        output.dayImageRelay
            .bind(to: dayImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    /// Binding On Off Button
    private func bindOnOffButton(output: HomeViewModel.Output) {
        output.buttonOnOffRelay
            .bind { [weak self] image in
                guard let self = self else { return }
                onOffButton.setImage(image?.resize(newWidth: 50), for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding BackGround Color
    private func bindBackGroundColor(output: HomeViewModel.Output) {
        output.backgroundColorRelay
            .bind { [weak self] color in
                guard let self = self else { return }
                view.backgroundColor = color
                safeAreaTopUIView.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding BlankView Shadow Color
    private func bindBlankViewShadowColor(output: HomeViewModel.Output) {
        output.blankUIViewShadowColorRelay
            .bind { [weak self] color in
                guard let self = self else { return }
                onUIView.layer.shadowColor = color.cgColor
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding toggle On - Off Button
    private func bindToggleOnOffButton(output: HomeViewModel.Output) {
        output.toggleOnOffButtonRelay
            .bind { [weak self] check in
                guard let self = self else { return }
                if check {
                    onUIView.removeFromSuperview()
                    addOnSubViews()
                    return
                }
                onUIView.removeFromSuperview()
                addOnSubViews()
            }
            .disposed(by: disposeBag)
    }
    
    ///  피드 추가 버튼
    private func bindAddWorkLogButton() {
        OnUIView().clickedAddWorklogButton
            .bind { [weak self] in
                guard let self = self else { return }
                presentInsertWorkLogView(insertFeed: nil)
            }
            .disposed(by: disposeBag)
    }
    
    /// Worklog 클릭한 경우
    private func bindSelectedFeedTableViewCell() {
        OnUIView().selectedWorklogTableViewCell
            .bind { [weak self] Worklog in
                guard let self = self else { return }
                let ClickWorklogView = ClickWorklogView()
                ClickWorklogView.feedSubject.onNext(Worklog)
                ClickWorklogView.successConnect
                    .bind { [weak self] in
                        guard let self = self else { return }
                        OnUIView().successAddWorklog.onNext(())
                    }
                    .disposed(by: disposeBag)
                
                ClickWorklogView.insertFeedSubject
                    .bind { [weak self] feed in
                        guard let self = self else { return }
                        presentInsertWorkLogView(insertFeed: feed)
                    }
                    .disposed(by: disposeBag)
                present(ClickWorklogView, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Present Insert W.L.
    private func presentInsertWorkLogView(insertFeed: Worklog?) {
        let InsertWorkLogView = InsertWorkLogView()
        if let insertFeed = insertFeed {
            InsertWorkLogView.insertFeed.onNext(insertFeed)
        }
        InsertWorkLogView.successAddWorklogSubject
            .bind { [weak self] in
                guard let self = self else { return }
                OnUIView().successAddWorklog.onNext(())
            }
            .disposed(by: disposeBag)
        present(InsertWorkLogView, animated: true)
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interval: CGFloat = 10
        let width: CGFloat = (collectionView.frame.width - interval * 2) / 8
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
}
