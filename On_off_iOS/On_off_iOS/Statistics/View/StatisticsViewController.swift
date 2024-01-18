//
//  StatisticsViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/7/24.
//

import FSCalendar
import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class StatisticsViewController: UIViewController {
    
    /// 달 차트 제목
    private lazy var monthChartTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    /// 스크롤 뷰
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// Content View
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 햇빛, 달 차트
    private lazy var monthChartView: DayChartCustomView = {
        let view = DayChartCustomView()
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 차트 날짜
    private lazy var weekChartTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    /// 일간 그래프
    private lazy var weekChartUIView: WeekChartCustomView = {
        let view = WeekChartCustomView(frame: CGRect(x: 0, y: 0,
                                        width: Int(view.safeAreaLayoutGuide.layoutFrame.width),
                                        height: Int(view.safeAreaLayoutGuide.layoutFrame.width)))
        view.backgroundColor = .clear
        return view
    }()
     
    /// 회고 작성 비율
    private lazy var writeRateUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 회고 작성 비율 제목
    private lazy var writeRateUILabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    /// 캘린더 백그라운드 뷰
    private lazy var calendarBackgroundUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 이전 달로 이동 버튼
    private let prevMonthButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .clear
        return btn
    }()
    
    /// 다음 달로 이동 버튼
    private let nextMonthButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .clear
        return btn
    }()
    
    /// 캘린더 뷰
    private lazy var calendarView: FSCalendar = {
        let view = FSCalendar()
        view.scrollDirection = .horizontal
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.locale = Locale(identifier: "ko_KR")
        view.allowsSelection = false
        
        // 오늘 날짜 색상 변경
        view.appearance.todayColor = .clear
        view.appearance.titleTodayColor = .black
        
        // 캘린더 week 뷰 설정
        view.appearance.weekdayTextColor = .black
        
        // 캘린더 헤더 뷰 설정
        view.appearance.headerMinimumDissolvedAlpha = 0.0
        view.appearance.headerTitleColor = .black
        view.appearance.headerDateFormat = "YYYY년 MM월"
        return view
    }()
    
    private let viewModel: StatisticsViewModel = StatisticsViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubViews()
        bind()
    }
    
    /// AddSubViews
    private func addSubViews() {
        view.addSubview(monthChartTitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(weekChartUIView)
        contentView.addSubview(weekChartTitleLabel)
        contentView.addSubview(monthChartView)
        contentView.addSubview(writeRateUIView)
        writeRateUIView.addSubview(writeRateUILabel)
        contentView.addSubview(calendarBackgroundUIView)
        calendarBackgroundUIView.addSubview(calendarView)
        calendarView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        
        contentView.addSubview(prevMonthButton)
        contentView.addSubview(nextMonthButton)
        
        constraints()
    }
    
    /// Set Constraints
    private func constraints() {
        monthChartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(monthChartTitleLabel.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
        }
        
        monthChartView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        weekChartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(monthChartView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        weekChartUIView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        weekChartUIView.snp.makeConstraints { make in
            make.top.equalTo(weekChartTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide.layoutFrame.width)
            make.height.equalTo(weekChartUIView.snp.width).multipliedBy(0.7)
        }
        
        writeRateUIView.snp.makeConstraints { make in
            make.top.equalTo(weekChartUIView.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(130)
        }
        
        writeRateUILabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(20)
        }
        
        calendarBackgroundUIView.snp.makeConstraints { make in
            make.top.equalTo(writeRateUIView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.width).multipliedBy(0.5)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        prevMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView.snp.centerY).multipliedBy(1.1)
            make.trailing.equalTo(calendarView.calendarHeaderView.snp.leading).offset(100)
        }
        
        nextMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView.snp.centerY).multipliedBy(1.1)
            make.leading.equalTo(calendarView.calendarHeaderView.snp.trailing).offset(-100)
        }
    }
    
    /// Binding
    private func bind() {
        let output = viewModel.createoutput(input: StatisticsViewModel.Input(prevButtonEvents: prevMonthButton.rx.tap,
                                                                             nextButtonEvents: nextMonthButton.rx.tap))
        
        bindWeekView(output: output)
        bindMonthView(output: output)
        bindWriteRateUILabel(output: output)
        bindMonthButtonAction(output: output)
    }
    
    /// binding WeekChartUIView Data
    private func bindWeekView(output: StatisticsViewModel.Output) {
        guard let statistics = output.weekStatisticsRelay.value else { return }
        weekChartTitleLabel.text = output.weekTitleRelay.value
        weekChartUIView.inputData(statistics: statistics)
    }
    
    /// binding MonthChartUIView Data
    private func bindMonthView(output: StatisticsViewModel.Output) {
        guard let statistics = output.monthStatisticsRelay.value else { return }
        monthChartView.inputData(statistics: statistics)
        monthChartTitleLabel.text = output.monthTitleRelay.value
    }
    
    /// binding Write Rate UILabel
    private func bindWriteRateUILabel(output: StatisticsViewModel.Output) {
        output.writeRateRelay
            .bind { [weak self] title in
                guard let self = self else { return }
                writeRateUILabel.attributedText = title
            }
            .disposed(by: disposeBag)
    }
    
    /// binding Month Button Action
    private func bindMonthButtonAction(output: StatisticsViewModel.Output) {
        output.moveMonthRelay
            .bind { [weak self] move in
                guard let self = self else { return }
                var dateComponents = DateComponents()
                dateComponents.month = move
                calendarView.currentPage = Calendar.current.date(byAdding: dateComponents, to: calendarView.currentPage)!
                calendarView.setCurrentPage(calendarView.currentPage, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension StatisticsViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: date, at: position) as? CalendarCell else { return FSCalendarCell()}
        cell.backgroundColor = .clear
        
        return cell
    }
}






import SwiftUI
struct VCPreViewStatisticsViewController:PreviewProvider {
    static var previews: some View {
        StatisticsViewController().toPreview().previewDevice("iPhone 15 Pro")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}

struct VCPreViewStatisticsViewController2:PreviewProvider {
    static var previews: some View {
        StatisticsViewController().toPreview().previewDevice("iPhone SE (3rd generation)")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

