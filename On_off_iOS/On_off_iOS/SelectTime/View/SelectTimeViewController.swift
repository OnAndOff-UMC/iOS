//
//  SelectTimeViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/18.
//

import SnapKit
import RxSwift
import RxCocoa
import UIKit

/// SelectTimeViewController
final class SelectTimeViewController : UIViewController {
    
    private lazy var clockImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "온보딩시계")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 받을 요일과 퇴근 시간을 골라주세요"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "퇴근 시간에 회고할 수 있도록 도와드릴게요"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private var dayButtons: [DayButton] = []
    private var daysOfWeek = [
        DayModel(name: "월", isChecked: false),
        DayModel(name: "화", isChecked: false),
        DayModel(name: "수", isChecked: false),
        DayModel(name: "목", isChecked: false),
        DayModel(name: "금", isChecked: false),
        DayModel(name: "토", isChecked: false),
        DayModel(name: "일", isChecked: false)]
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: dayButtons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
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
    private var viewModel: SelectTimeViewModel
    
    // MARK: - Init
    init(viewModel: SelectTimeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCheckButtonView()
        setupDayButtons()
        addSubiews()
        setupBindings()
    }
    
    /// setupDayButtons
    private func setupDayButtons() {
        daysOfWeek.forEach { dayData in
            let button = DayButton()
            button.dayModel = dayData
            dayButtons.append(button)
        }
    }
    
    /// addSubiews
    private func addSubiews() {
        view.addSubview(clockImage)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(stackView)
        
        view.addSubview(stateLabel)
        view.addSubview(selectedTimeButton)
        view.addSubview(downImage)
        
        view.addSubview(checkButtonView)
        checkButtonView.addSubview(checkButton)
        
        configureConstraint()
    }
    
    /// configureConstraint
    private func configureConstraint() {
        clockImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview().inset(80)
            make.height.equalTo(clockImage.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(clockImage.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        selectedTimeButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.height.equalTo(selectedTimeButton.snp.width).multipliedBy(0.13)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        downImage.snp.makeConstraints { make in
            make.trailing.equalTo(selectedTimeButton.snp.trailing).inset(10)
            make.verticalEdges.equalTo(selectedTimeButton.snp.verticalEdges).inset(8)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(selectedTimeButton.snp.top).offset(-5)
            make.leading.equalTo(selectedTimeButton.snp.leading)
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
    /// DatePicker 값 바인딩
    private func setupBindings() {
        let input = SelectTimeViewModel.Input(startButtonTapped: checkButton.rx.tap.asObservable())
        let output = viewModel.bind(input: input)
        
        selectedTimeButton.rx.tap
            .bind { [weak self] in
                self?.showTimePicker()
            }
            .disposed(by: disposeBag)
                

        output.moveToNext
            .subscribe(onNext: { [weak self] in
                self?.moveToMain()
            })
            .disposed(by: disposeBag)
        
    }
    
    /// 확인  버튼 속성 설정
    private func setupCheckButtonView(){
        let cornerRadius = UICalculator.calculate(for: .longButtonCornerRadius, width: view.frame.width)
        checkButtonView.layer.cornerRadius = cornerRadius
        checkButtonView.layer.masksToBounds = true
    }
    /// timePicker 창 보기
    private func showTimePicker() {
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
        let selectAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.updateTimeLabel(datePicker.date)
        })
        alertController.addAction(selectAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// updateTimeLabel: 피커선택후 라벨 업데이트
    private func updateTimeLabel(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm" // 오전/오후, 12시간
        formatter.amSymbol = "오전" // 오전
        formatter.pmSymbol = "오후" // 오후
        selectedTimeButton.setTitle(formatter.string(from: date), for: .normal)
    }
    
    /// 메인 화면으로 이동
    private func moveToMain() {
        let bookmarkViewModel = BookmarkViewModel()
        let vc = BookmarkViewController(viewModel: bookmarkViewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
