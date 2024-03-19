//
//  OnUIView.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/17/24.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

/// On 상태일 때 표시되는 UIView
final class OnUIView: UIView {
    
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
    
    //오늘의 다짐 제목 버튼
    private lazy var todayResolutionButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘의 다짐", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.OnOffMain, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    /// 제목 옆 벡터 아이콘 배경
    private lazy var todayResolutionLabelBackgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffPurple
        view.alpha = 0.4
        return view
    }()
    
    /// 오늘의 다짐 제목 옆 벡터 아이콘 >
    private lazy var todayResolutionIconImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()

    /// 오늘의 다짐 작성 했는지 안했는지 확인하는 UIView
    private lazy var todayResolutionUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffLightMain
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 오늘의 회고 제목
    private lazy var resolutionTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    //오늘의 회고 완료한 경우 TableViewCell
    private lazy var todayresolutionDoneTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .OnOffLightMain
        view.layer.cornerRadius = 20
        view.register(TodayResolutionTableViewCell.self,
                      forCellReuseIdentifier: CellIdentifier.TodayResolutionTableViewCell.rawValue)
        return view
    }()
    
    /// 업무일지제목
    private lazy var feedTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle("업무 일지", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.OnOffMain, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    /// 업무일지 제목 옆 벡터 아이콘 배경
    private lazy var feedlabelBackgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffPurple
        view.alpha = 0.4
        return view
    }()
    
    /// 업무일지 제목 옆 벡터 아이콘 +
    private lazy var feedPlusIconImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()
    
    /// Worklog 확인하는 UIView
    private lazy var feedUITableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .OnOffLightMain
        view.layer.cornerRadius = 20
        view.register(WorkLogTableViewCell.self,
                      forCellReuseIdentifier: CellIdentifier.WorkLogTableViewCell.rawValue)
        return view
    }()
    
//    /// 날짜 라벨
//    private lazy var dateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "2024 - November"
//        label.backgroundColor = .clear
//        label.textColor = .OnOffMain
//        label.font = .systemFont(ofSize: 18, weight: .bold)
//        return label
//    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = OnUIViewModel()
    
    var clickedAddWorklogButton: PublishSubject<Void> = PublishSubject()
    
    var moveTodayResolutionViewController: PublishSubject<String> = PublishSubject()
    
    /// 선택한 날짜
    var selectedDate: PublishSubject<String> = PublishSubject()
    var successAddWorklog: PublishSubject<Void> = PublishSubject()
    var successAddResolution: PublishSubject<Void> = PublishSubject()
    var selectedWorklogTableViewCell: PublishSubject<WorkGetlogDTO> = PublishSubject()
    
    //Resolution 부분 데이터 바뀔 수도 있어서 수정필요
    var selectedResolutionTableViewCell:
    PublishSubject<Resolution> = PublishSubject()
    
    private var loadWLFeed: PublishSubject<Void> = PublishSubject()
    var moveStartToWriteViewController: PublishSubject<String> = PublishSubject()
    var loadTRFeed: PublishSubject<Void> = PublishSubject()
    private var clickCheckMarkOfWLFeed: PublishSubject<WorkGetlogDTO> = PublishSubject()
    
    
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
        loadWLFeed.onNext(())
        loadTRFeed.onNext(())
    }
    
    /// Add View
    private func addSubViews(output: OnUIViewModel.Output) {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(todayResolutionButton)
        contentView.addSubview(todayResolutionLabelBackgroundUIView)
        todayResolutionLabelBackgroundUIView.addSubview(todayResolutionIconImageButton)
        contentView.addSubview(todayResolutionUIView)
        contentView.addSubview(todayresolutionDoneTableView)
        contentView.addSubview(feedlabelBackgroundUIView)
        contentView.addSubview(feedTitleButton)
        feedlabelBackgroundUIView.addSubview(feedPlusIconImageButton)
        contentView.addSubview(feedUITableView)
//        contentView.addSubview(dateLabel)
        
        constraints(output: output)
    }
    
    
    /// Constraints
    private func constraints(output: OnUIViewModel.Output) {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
//            make.top.equalToSuperview()
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(1000)
            make.width.equalTo(scrollView.snp.width)
            
//            make.top.equalTo(scrollView.snp.top)
//            make.leading.equalTo(scrollView.snp.leading)
//            make.trailing.equalTo(scrollView.snp.trailing)
//            make.bottom.equalTo(scrollView.snp.bottom)
//            make.width.equalTo(scrollView.snp.width)
        }
        
        todayResolutionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        todayResolutionLabelBackgroundUIView.snp.makeConstraints { make in
            make.height.equalTo(todayResolutionButton.snp.height).multipliedBy(0.5)
            make.leading.equalTo(todayResolutionButton.snp.trailing).offset(10)
            make.centerY.equalTo(todayResolutionButton.snp.centerY)
            make.width.equalTo(todayResolutionLabelBackgroundUIView.snp.height)
        }
        
        todayResolutionLabelBackgroundUIView.layoutIfNeeded()
        todayResolutionLabelBackgroundUIView.layer.cornerRadius = todayResolutionLabelBackgroundUIView.frame.height * 0.65
        
        todayResolutionIconImageButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        todayResolutionUIView.snp.makeConstraints { make in
            make.top.equalTo(todayResolutionButton.snp.bottom).offset(10)
            make.leading.equalTo(todayResolutionButton.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        todayresolutionDoneTableView.snp.makeConstraints {
            make in
            make.top.equalTo(todayResolutionButton.snp.bottom).offset(10)
            make.leading.equalTo(todayResolutionButton.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            output.tableViewHeightConstraint.accept(make.height.equalTo(200).constraint)
        }
        
        
        feedTitleButton.snp.makeConstraints { make in
            make.top.equalTo(todayResolutionUIView.snp.bottom).offset(20)
            make.leading.equalTo(todayResolutionButton.snp.leading)
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
        
        feedUITableView.snp.makeConstraints { make in
            make.top.equalTo(feedTitleButton.snp.bottom).offset(10)
            make.leading.equalTo(feedTitleButton.snp.leading)
            make.trailing.equalToSuperview().offset(-20)
            output.tableViewHeightConstraint.accept(make.height.equalTo(200).constraint)
        }
        
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(feedUITableView.snp.bottom).offset(20)
//            make.leading.equalToSuperview().offset(10)
//        }
        
    }
    
    /// Binding
    private func bind() {
        let output = viewModel.createOutput(input: OnUIViewModel.Input(loadWLFeed: loadWLFeed,
                                                                       clickCheckMarkOfWLFeed: clickCheckMarkOfWLFeed,
                                                                       selectedDate: selectedDate,
                                                                       successAddWorklog: successAddWorklog))
        addSubViews(output: output)
        bindTableView(output: output)
        bindTableViewHeight(output: output)
        bindClickTableViewCell(output: output)
//        bindSelectedMonth(output: output)
        bindFeedEvents()
    }
    
    // Worklog 제목 버튼 및 이미지 버튼
    private func bindFeedEvents() {
        feedTitleButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                clickedAddWorklogButton.onNext(())
            }
            .disposed(by: disposeBag)
        
        feedPlusIconImageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                print("Button tapped")
                self.clickedAddWorklogButton.onNext(())
            })
            .disposed(by: disposeBag)
    }

    /// Binding Work log Table View
    private func bindTableViewHeight(output: OnUIViewModel.Output) {
        output.workLogRelay
            .bind { list in
                if list.count > 4 {
                    output.tableViewHeightConstraint.value?.update(offset: 200 + (50 * (list.count - 4)))
                    return
                }
                output.tableViewHeightConstraint.value?.update(offset: 200)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Work Log Table View
    private func bindTableView(output: OnUIViewModel.Output) {
        output.workLogRelay
            .bind(to: feedUITableView.rx.items(cellIdentifier: CellIdentifier.WorkLogTableViewCell.rawValue,
                                               cellType: WorkLogTableViewCell.self))
        { [weak self] row, element, cell in
            guard let self = self else { return }
            cell.inputData(Worklog: element)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.checkMarkButtonEvents
                .bind { [weak self] in
                    guard let self = self else { return }
                    clickCheckMarkOfWLFeed.onNext(element)
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        feedUITableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// Binding Click Table View Cell
    private func bindClickTableViewCell(output: OnUIViewModel.Output) {
        feedUITableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                let Worklog = output.workLogRelay.value[indexPath.row]
                selectedWorklogTableViewCell.onNext(Worklog)
            }
            .disposed(by: disposeBag)
    }
    
//    /// Bind Selected Month
//    private func bindSelectedMonth(output: OnUIViewModel.Output) {
//        output.selectedDate
//            .bind { [weak self] date in
//                guard let self = self else { return }
//                dateLabel.text = date
//            }
//            .disposed(by: disposeBag)
//    }
}

extension OnUIView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
