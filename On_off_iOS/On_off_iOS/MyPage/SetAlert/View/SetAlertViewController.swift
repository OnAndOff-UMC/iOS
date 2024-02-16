//
//  SetAlertViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/16/24.
//

import Foundation
import SnapKit
import UIKit
import RxSwift

final class SetAlertViewController: UIViewController {
    
    /// 오늘의 회고 알림 제목
    private lazy var alertTitle: UILabel = {
        let label = UILabel()
        label.text = "오늘의 회고 알림"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    /// Check Alert Button
    private lazy var checkAlertButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "turnOn"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    /// 알림 시간 제목
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림시간"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mondayButton,
                                                       tuesdayButton,
                                                       wednesdayButton,
                                                       thursdayButton,
                                                       fridayButton,
                                                       saturdayButton,
                                                       sundayButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    /// 월 버튼
    private lazy var mondayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("월", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    /// 화 버튼
    private lazy var tuesdayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("화", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    /// 수 버튼
    private lazy var wednesdayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("수", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    /// 목 버튼
    private lazy var thursdayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("목", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    /// 금 버튼
    private lazy var fridayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("금", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    /// 토 버튼
    private lazy var saturdayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("토", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    /// 일 버튼
    private lazy var sundayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("일", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Status"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var downImage : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for:.normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var selectedTimeButton: UIButton = {
        let button = UIButton()
        button.setTitle("오후 00:00", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    /// 확인버튼
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("알람 설정 저장하기", for: .normal)
        button.titleLabel?.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    private lazy var checkButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffMain
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = SetAlertViewModel()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCheckButtonView()
        addSubiews()
        setupBindings()
    }
    
    /// Add Subiews
    private func addSubiews() {
        view.addSubview(alertTitle)
        view.addSubview(checkAlertButton)
        
        view.addSubview(checkButtonView)
        checkButtonView.addSubview(checkButton)
        
        configureConstraint()
    }
    
    /// Configure Constraint
    private func configureConstraint() {
        alertTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        checkAlertButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(alertTitle.snp.centerY)
        }
        
        
        checkButtonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(checkButtonView.snp.width).multipliedBy(0.15)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        checkButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// Alert Time AddSubview
    private func alertTimeAddSubview() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        view.addSubview(stateLabel)
        view.addSubview(selectedTimeButton)
        view.addSubview(downImage)
        
        alertTimeConstraints()
    }
    
    /// Alert Time Constraints
    private func alertTimeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(alertTitle.snp.bottom).offset(40)
            make.leading.equalTo(alertTitle.snp.leading)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        selectedTimeButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(selectedTimeButton.snp.width).multipliedBy(0.13)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        downImage.snp.makeConstraints { make in
            make.trailing.equalTo(selectedTimeButton.snp.trailing).inset(10)
            make.verticalEdges.equalTo(selectedTimeButton.snp.verticalEdges).inset(8)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(selectedTimeButton.snp.top).offset(-5)
            make.leading.equalTo(selectedTimeButton.snp.leading)
        }
    }
    
    /// DatePicker 값 바인딩
    private func setupBindings() {
        let input = SetAlertViewModel.Input(checkAlertButtonEvents: checkAlertButton.rx.tap,
                                            checkButtonEvents: checkButton.rx.tap,
                                            mondayButtonEvents: mondayButton.rx.tap,
                                            tuesdayButtonEvents: tuesdayButton.rx.tap,
                                            wednesdayButtonEvents: wednesdayButton.rx.tap,
                                            thursdayButtonEvents: thursdayButton.rx.tap,
                                            fridayButtonEvents: fridayButton.rx.tap,
                                            saturdayButtonEvents: saturdayButton.rx.tap, 
                                            sundayButtonEvents: sundayButton.rx.tap)
        let output = viewModel.bind(input: input)
        
        bindCheckButton(output: output)
        bindSelectedTimeButton(output: output)
        bindCheckAlertButtonRelay(output: output)
        bindWeekInformationRelay(output: output)
        bindSelectedTime(output: output)
    }
    
    /// Bind Check Button
    private func bindCheckButton(output: SetAlertViewModel.Output) {
        output.successConnectSubject
            .bind { [weak self] in
                guard let self = self else { return }
                moveToMain()
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Check Button
    private func bindCheckAlertButtonRelay(output: SetAlertViewModel.Output) {
        output.checkAlertButtonRelay
            .bind { [weak self] check in
                guard let self = self else { return }
                if check {
                    checkAlertButton.setImage(UIImage(named: "turnOn"), for: .normal)
                    alertTimeAddSubview()
                    return
                }
                checkAlertButton.setImage(UIImage(named: "turnOff"), for: .normal)
                titleLabel.removeFromSuperview()
                stackView.removeFromSuperview()
                stateLabel.removeFromSuperview()
                downImage.removeFromSuperview()
                selectedTimeButton.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Selected Time Button
    private func bindSelectedTimeButton(output: SetAlertViewModel.Output) {
        selectedTimeButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                showTimePicker(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Week Information Relay
    private func bindWeekInformationRelay(output: SetAlertViewModel.Output) {
        output.weekInformationRelay
            .bind { [weak self] info in
                guard let self = self else { return }
                setDayStatus(view: mondayButton, isChecked: info?.monday ?? false)
                setDayStatus(view: tuesdayButton, isChecked: info?.tuesday ?? false)
                setDayStatus(view: wednesdayButton, isChecked: info?.wednesday ?? false)
                setDayStatus(view: thursdayButton, isChecked: info?.thursday ?? false)
                setDayStatus(view: fridayButton, isChecked: info?.friday ?? false)
                setDayStatus(view: saturdayButton, isChecked: info?.saturday ?? false)
                setDayStatus(view: sundayButton, isChecked: info?.sunday ?? false)
            }
            .disposed(by: disposeBag)
    }
    
    /// 요일 선택된 날짜 효과 적용
    private func setDayStatus(view: UIButton, isChecked: Bool) {
        if isChecked {
            view.setTitleColor(.white, for: .normal)
            view.backgroundColor = .OnOffMain
            return
        }
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .lightGray
    }
    
    /// Binding Selected Time
    private func bindSelectedTime(output: SetAlertViewModel.Output) {
        output.selectedAlertTimeRelay
            .bind { [weak self] date in
                guard let self = self else { return }
                selectedTimeButton.setTitle(date, for: .normal)
            }
            .disposed(by: disposeBag)
       
    }
    
    /// 확인  버튼 속성 설정
    private func setupCheckButtonView(){
        let cornerRadius = UICalculator.calculate(for: .longButtonCornerRadius, width: view.frame.width)
        checkButtonView.layer.cornerRadius = cornerRadius
        checkButtonView.layer.masksToBounds = true
    }
    
    /// timePicker 창 보기
    private func showTimePicker(output: SetAlertViewModel.Output) {
        let alertController = UIAlertController(title: "시간 선택", message: nil, preferredStyle: .actionSheet)
        
        /// datePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        
        /// pickerContainer
        let pickerContainer = UIView()
        
        /// picker addSubViews
        pickerContainer.addSubview(datePicker)
        alertController.view.addSubview(pickerContainer)
        
        /// picker Constraints
        pickerContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(45)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(pickerContainer.snp.width).multipliedBy(0.45)
        }
        
        datePicker.snp.makeConstraints { make in
            make.edges.equalTo(pickerContainer)
        }
        
        alertController.view.snp.makeConstraints { make in
            make.height.equalTo(pickerContainer.snp.width)
        }
        
        /// Alert action
        let selectAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            updateTimeLabel(datePicker.date, output: output)
        })
        alertController.addAction(selectAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// updateTimeLabel: 피커선택후 라벨 업데이트
    private func updateTimeLabel(_ date: Date, output: SetAlertViewModel.Output) {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm" // 오전/오후, 12시간
        formatter.amSymbol = "오전" // 오전
        formatter.pmSymbol = "오후" // 오후
        let date = formatter.string(from: date)
        output.selectedAlertTimeRelay.accept(date)
    }
    
    /// 메인 화면으로 이동
    private func moveToMain() {
        let tabBarController = TabBarController()
        navigationController?.pushViewController(tabBarController, animated: true)
    }

}
