//
//  InsertWorkLogView.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/13/24.
//


import Foundation
import SnapKit
import RxSwift
import UIKit

/// 워라벨 피드 입력
final class InsertWorkLogView: DimmedViewController {
    
    /// 배경 뷰
    private lazy var baseUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    /// TextField 배경 뷰
    private lazy var textFieldCornerUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.OnOffMain.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    /// 입력받는 TextField
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(string: "워라벨 피드를 적어주세요",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        view.textColor = .black
        view.font = .pretendard(size: 14, weight: .medium)
        return view
    }()
    
    /// 글자수 세기 라벨
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "(0/30)"
        label.backgroundColor = .clear
        label.textColor = .lightGray
        label.font = .pretendard(size: 12, weight: .light)
        return label
    }()
    
    /// 완료 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "check"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = InsertWorkLifeBalanceFeedViewModel()
    var successAddFeedSubject: PublishSubject<Void> = PublishSubject<Void>()
    var insertFeed: PublishSubject<Feed> = PublishSubject<Feed>()
    
    // MARK: - Init
    init() {
        super.init(durationTime: 0.3, alpha: 0.7)
        addSubviews()
        bind()
        setupKeyboardEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true)
    }
    
    /// Add Subviews
    private func addSubviews() {
        view.addSubview(baseUIView)
        baseUIView.addSubview(textFieldCornerUIView)
        baseUIView.addSubview(doneButton)
        
        textFieldCornerUIView.addSubview(textField)
        baseUIView.addSubview(textCountLabel)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        baseUIView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height/6)
        }
        
        textFieldCornerUIView.snp.makeConstraints { make in
            make.height.equalTo(baseUIView.snp.height).multipliedBy(0.25)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(doneButton.snp.leading).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerY.equalToSuperview().offset(-10)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(textFieldCornerUIView.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textFieldCornerUIView.snp.trailing).offset(-10)
            make.centerY.equalTo(textFieldCornerUIView.snp.centerY)
        }
    }
    
    /// Binding
    private func bind() {
        let input = InsertWorkLifeBalanceFeedViewModel.Input(textFieldEvents: textField.rx.text.orEmpty,
                                                             doneButtonEvents: doneButton.rx.tap,
                                                             insertFeed: insertFeed)
        
        let output = viewModel.createOutput(input: input)
        
        bindTextRelay(output: output)
        bindtextCountRelay(output: output)
        bindSuccessAddFeedRelay(output: output)
    }
    
    /// Binding TextField Relay
    private func bindTextRelay(output: InsertWorkLifeBalanceFeedViewModel.Output) {
        output.textRelay
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    /// Binding Text Count Relay
    private func bindtextCountRelay(output: InsertWorkLifeBalanceFeedViewModel.Output) {
        output.textCountRelay
            .bind { [weak self] text in
                guard let self = self else { return }
                textCountLabel.text = "(\(text)/30)"
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding When Success Add Feed
    private func bindSuccessAddFeedRelay(output: InsertWorkLifeBalanceFeedViewModel.Output) {
        output.successAddFeedRelay
            .bind { [weak self] check in
                guard let self = self else { return }
                dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    successAddFeedSubject.onNext(())
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// 키보드 크기 정보를 받기 위한 Notification 등록
    private func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    /// 키보드가 올라올 때 전체적인 뷰를 키보드 크기 만큼 올림
    @objc
    private func keyboardWillShow(_ sender: Notification) {
        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height

        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight
        }
    }
    
    /// 키보드가 내려올 때 전체적인 뷰를 키보드 크기 만큼 올림
    @objc
    private func keyboardWillHide(_ sender: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
}
