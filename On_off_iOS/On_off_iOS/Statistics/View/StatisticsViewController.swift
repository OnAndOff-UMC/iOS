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
    
    ///
    private lazy var chartUIView: ChartCustomView = {
        let view = ChartCustomView(frame: CGRect(x: 0, y: 0,
                                        width: Int(view.safeAreaLayoutGuide.layoutFrame.width),
                                        height: Int(view.safeAreaLayoutGuide.layoutFrame.width)))
        view.backgroundColor = .green
        return view
    }()
    
    /// 차트 날짜
    private lazy var chartTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "11월 3주차"
        label.font = .boldSystemFont(ofSize: 17)
        return label
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
        constraints()
    }
    
    /// Set Constraints
    private func constraints() {
    
        chartUIView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        chartUIView.transform = CGAffineTransform(rotationAngle: -(.pi / 2)).translatedBy(x: 0, y: 0)
        
        chartTitle.snp.makeConstraints { make in
            make.bottom.equalTo(chartUIView.snp.top).offset(-20)
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

