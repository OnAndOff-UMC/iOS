//
//  ClickWorklogView.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
//

import Foundation
import UIKit
import SnapKit

final class ClickWorklogView: DimmedViewController {
    
    /// 배경 뷰
    private lazy var baseUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 제목 라벨
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "워라벨 피드"
        label.textColor = .OnOffMain
        label.font = .pretendard(size: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 부제목 라벨
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendard(size: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 구분 선
    private lazy var divideLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffMain
        return view
    }()
    
    /// 완료 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .OnOffMain
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        button.layer.cornerRadius = 15
        return button
    }()
    
    /// 미루기 버튼
    private lazy var delayButton: FeedOptionButton = {
        let button = FeedOptionButton()
        button.inputData(image: "calendar",
                         title: "내일로 미루기")
        button.backgroundColor = .clear
        return button
    }()
    
    /// Insert Button
    private lazy var insertButton: FeedOptionButton = {
        let button = FeedOptionButton()
        button.inputData(image: "insert",
                         title: "수정하기")
        button.backgroundColor = .clear
        return button
    }()
    
    /// Delete 버튼
    private lazy var deleteButton: FeedOptionButton = {
        let button = FeedOptionButton()
        button.inputData(image: "delete",
                         title: "삭제하기")
        button.backgroundColor = .clear
        return button
    }()
    
    /// 옵션 StackView
    private lazy var optionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [delayButton, insertButton, deleteButton])
        view.backgroundColor = .clear
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    
    /// 내일로 미루기 body 라벨
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "'asfasfsfsfs'를\n다음날인 로 미루시겠어요?"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .pretendard(size: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 완료 버튼
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.OnOffMain, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.OnOffMain.cgColor
        return button
    }()
    
    /// 최종 미루기  버튼
    private lazy var completeDelayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .OnOffMain
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        button.layer.cornerRadius = 15
        return button
    }()
    
    /// 최종 삭제 버튼
    private lazy var completeDeleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .OnOffMain
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        button.layer.cornerRadius = 15
        return button
    }()
    
    /// 버튼 StackView
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 15
        return view
    }()
    
    var feedSubject: PublishSubject<Worklog> = PublishSubject()
    var successConnect: PublishSubject<Void> = PublishSubject()
    var insertFeedSubject: PublishSubject<Worklog> = PublishSubject()
    private let disposeBag = DisposeBag()
    private let viewModel = ClickWorkLifeBalanceFeedViewModel()
    
    // MARK: - Init
    init() {
        super.init(durationTime: 0.3, alpha: 0.7)
        addSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Add Subviews
    private func addSubviews() {
        view.addSubview(baseUIView)
        baseUIView.addSubview(titleLabel)
        baseUIView.addSubview(subTitleLabel)
        baseUIView.addSubview(divideLineView)
        baseUIView.addSubview(doneButton)
        baseUIView.addSubview(optionStackView)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        baseUIView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        divideLineView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        optionStackView.snp.makeConstraints { make in
            make.top.equalTo(divideLineView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(doneButton.snp.top).offset(-10)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    /// Delay AddSubViews
    private func delayAddSubViews() {
        optionStackView.removeFromSuperview()
        doneButton.removeFromSuperview()
        baseUIView.addSubview(contentLabel)
        baseUIView.addSubview(buttonStackView)
        
        delayConstraints()
    }
    
    /// Delay Constraints
    private func delayConstraints() {
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(divideLineView.snp.bottom).offset(30)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-30)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
        }
    }
    
    /// Binding
    private func bind() {
        let input = ClickWorkLifeBalanceFeedViewModel.Input(completeDelayButtonEvents: completeDelayButton.rx.tap,
                                                            deleteButtonEvents: completeDeleteButton.rx.tap,
                                                            selectedFeed: feedSubject)
        
        let output = viewModel.createOutput(input: input)
        
        bindCancelButton()
        bindDoneButton()
        bindInsertButton(output: output)
        bindDeleteButton(output: output)
        bindDelayButton(output: output)
        bindSuccessDelay(output: output)
        bindSelectedFeed(output: output)
    }
    
    /// Bind Selected Feed
    private func bindSelectedFeed(output: ClickWorkLifeBalanceFeedViewModel.Output) {
        output.selectedFeedRelay
            .bind { [weak self] feed in
                guard let self = self, let content = feed?.content else { return }
                subTitleLabel.text = content
            }
            .disposed(by: disposeBag)
    }
    
    /// 내일로 미루기 버튼
    private func bindDelayButton(output: ClickWorkLifeBalanceFeedViewModel.Output) {
        delayButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      let content = output.selectedFeedRelay.value?.content else { return }
                delayAddSubViews()
                
                buttonStackView.removeArrangedSubview(completeDeleteButton)
                buttonStackView.addArrangedSubview(cancelButton)
                buttonStackView.addArrangedSubview(completeDelayButton)
                
                completeDelayButton.setTitle("미루기", for: .normal)
                contentLabel.text = "\(content)를\n다음날인 \(output.nextDay.value)로 미루시겠어요?"
            }
            .disposed(by: disposeBag)
    }
    
    /// 확인 버튼
    private func bindDoneButton() {
        doneButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 취소 버튼
    private func bindCancelButton() {
        cancelButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 수정하기 버튼
    private func bindInsertButton(output: ClickWorkLifeBalanceFeedViewModel.Output) {
        insertButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let feed = output.selectedFeedRelay.value else { return }
                dismiss(animated: true)
                insertFeedSubject.onNext(feed)
            }
            .disposed(by: disposeBag)
    }
    
    /// 내일로 미루기 버튼
    private func bindDeleteButton(output: ClickWorkLifeBalanceFeedViewModel.Output) {
        deleteButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      let content = output.selectedFeedRelay.value?.content else { return }
                delayAddSubViews()
                buttonStackView.removeArrangedSubview(completeDelayButton)
                buttonStackView.addArrangedSubview(cancelButton)
                buttonStackView.addArrangedSubview(completeDeleteButton)
                completeDeleteButton.setTitle("삭제", for: .normal)
                contentLabel.text = "\(content)를\n 삭제하시겠어요?"
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Success Delay
    private func bindSuccessDelay(output: ClickWorkLifeBalanceFeedViewModel.Output) {
        output.successConnectRelay
            .bind { [weak self] _ in
                guard let self = self else { return }
                dismiss(animated: true)
                successConnect.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
}

import SwiftUI
import RxSwift
struct VCPreViewClickWorkLifeBalanceFeedView: PreviewProvider {
    static var previews: some View {
        ClickWorkLifeBalanceFeedView().toPreview().previewDevice("iPhone 14 Pro")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}
struct VCPreViewClickWorkLifeBalanceFeedView2: PreviewProvider {
    static var previews: some View {
        ClickWorkLifeBalanceFeedView().toPreview().previewDevice("iPhone 11")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}
