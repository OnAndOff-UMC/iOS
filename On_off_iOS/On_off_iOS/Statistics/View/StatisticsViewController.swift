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
    
    /// 맨위 라벨
    private lazy var dayChartTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "2023년 11월"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    /// 햇빛, 달 차트
    private lazy var dayChartView: DayChartCustomView = {
        let view = DayChartCustomView()
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 차트 날짜
    private lazy var chartTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "11월 3주차"
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    /// 일간 그래프
    private lazy var chartUIView: WeekChartCustomView = {
        let view = WeekChartCustomView(frame: CGRect(x: 0, y: 0,
                                        width: Int(view.safeAreaLayoutGuide.layoutFrame.width),
                                        height: Int(view.safeAreaLayoutGuide.layoutFrame.width)))
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubViews()
    }
    
    
    /// AddSubViews
    private func addSubViews() {
        view.addSubview(chartUIView)
        view.addSubview(chartTitle)
        view.addSubview(dayChartTitle)
        view.addSubview(dayChartView)
        constraints()
    }
    
    
    /// Set Constraints
    private func constraints() {
        dayChartTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        dayChartView.snp.makeConstraints { make in
            make.top.equalTo(dayChartTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        chartUIView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        chartUIView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide.layoutFrame.width)
            make.height.equalTo(chartUIView.snp.width).multipliedBy(0.7)
        }
        
        chartTitle.snp.makeConstraints { make in
            make.bottom.equalTo(chartUIView.snp.top).offset(-30)
            make.leading.equalToSuperview().offset(20)
        }
        
   
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

