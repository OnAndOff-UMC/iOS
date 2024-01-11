//
//  StatisticsViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/7/24.
//

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
    
    private let viewModel: StatisticsViewModel = StatisticsViewModel()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubViews()
        bind()
    }
    
    /// AddSubViews
    private func addSubViews() {
        view.addSubview(weekChartUIView)
        view.addSubview(weekChartTitleLabel)
        view.addSubview(monthChartTitleLabel)
        view.addSubview(monthChartView)
        
        constraints()
    }
    
    /// Set Constraints
    private func constraints() {
        monthChartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        monthChartView.snp.makeConstraints { make in
            make.top.equalTo(monthChartTitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        weekChartUIView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        weekChartUIView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide.layoutFrame.width)
            make.height.equalTo(weekChartUIView.snp.width).multipliedBy(0.7)
        }
        
        weekChartTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(weekChartUIView.snp.top).offset(-30)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    /// binding
    private func bind() {
        let output = viewModel.createoutput()
        
        bindWeekView(output: output)
        bindMonthView(output: output)
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

