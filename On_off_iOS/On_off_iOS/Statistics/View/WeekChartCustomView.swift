//
//  ChartCustomview.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/9/24.
//

import Foundation
import UIKit

final class WeekChartCustomView: UIView {
    
    /// Monday
    private lazy var mondayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .yellow
        return view
    }()
    
    /// Monday Title
    private lazy var mondayTitle: UILabel = {
        let label = UILabel()
        label.text = "Mon"
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        return label
    }()
    
    /// Tuesday
    private lazy var tuesdayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .yellow
        
        return view
    }()
    
    /// Tuesday Title
    private lazy var tuesdayTitle: UILabel = {
        let label = UILabel()
        label.text = "Tue"
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// Wendseday
    private lazy var wednesdayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .yellow
        view.setProgress(0.4, animated: true)
        return view
    }()
    
    /// Wendseday Title
    private lazy var wednesdayTitle: UILabel = {
        let label = UILabel()
        label.text = "Wed"
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// Thursday
    private lazy var thursdayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .yellow
        view.setProgress(0.4, animated: true)
        return view
    }()
    
    /// Thursday Title
    private lazy var thursdayTitle: UILabel = {
        let label = UILabel()
        label.text = "Thu"
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// Friday
    private lazy var fridayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .yellow
        view.setProgress(0.4, animated: true)
        return view
    }()
    
    /// Friday Title
    private lazy var fridayTitle: UILabel = {
        let label = UILabel()
        label.text = "Fri"
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        return label
    }()
    
    /// Saturday
    private lazy var saturdayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .yellow
        view.setProgress(0.4, animated: true)
        return view
    }()
    
    /// Saturday Title
    private lazy var saturdayTitle: UILabel = {
        let label = UILabel()
        label.text = "Sat"
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// Sunday
    private lazy var sundayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.trackTintColor = .OnOffLightPurple
        view.progressTintColor = .yellow
        view.setProgress(0.4, animated: true)
        return view
    }()
    
    /// Sunday Title
    private lazy var sundayTitle: UILabel = {
        let label = UILabel()
        label.text = "Sun"
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// 요일 StackView
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mondayProgressView,
                                                  tuesdayProgressView,
                                                  wednesdayProgressView,
                                                  thursdayProgressView,
                                                  fridayProgressView,
                                                  saturdayProgressView,
                                                  sundayProgressView])
        view.backgroundColor = .clear
        view.distribution = .fillEqually
        view.spacing = 15
        view.axis = .vertical
        return view
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// AddSubViews
    private func addSubViews() {
        addSubview(stackView)
        
        addSubview(mondayTitle)
        addSubview(tuesdayTitle)
        addSubview(wednesdayTitle)
        addSubview(thursdayTitle)
        addSubview(fridayTitle)
        addSubview(saturdayTitle)
        addSubview(sundayTitle)
        constraints()
    }
    
    
    /// Set Constraints
    private func constraints() {
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(stackView.snp.width)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.frame.width*2/3);
        }

        stackView.arrangedSubviews.forEach { view in
            view.layer.cornerRadius = view.frame.height * 3
        }
         
        mondayTitle.snp.makeConstraints { make in
            make.centerY.equalTo(mondayProgressView.snp.centerY)
            make.trailing.equalTo(mondayProgressView.snp.leading)
        }
        mondayTitle.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        
        tuesdayTitle.snp.makeConstraints { make in
            make.centerY.equalTo(tuesdayProgressView.snp.centerY)
            make.centerX.equalTo(mondayTitle.snp.centerX)
        }
        tuesdayTitle.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        
        wednesdayTitle.snp.makeConstraints { make in
            make.centerY.equalTo(wednesdayProgressView.snp.centerY)
            make.centerX.equalTo(mondayTitle.snp.centerX)
        }
        wednesdayTitle.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        
        thursdayTitle.snp.makeConstraints { make in
            make.centerY.equalTo(thursdayProgressView.snp.centerY)
            make.centerX.equalTo(mondayTitle.snp.centerX)
        }
        thursdayTitle.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        
        fridayTitle.snp.makeConstraints { make in
            make.centerY.equalTo(fridayProgressView.snp.centerY)
            make.centerX.equalTo(mondayTitle.snp.centerX)
        }
        fridayTitle.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        
        saturdayTitle.snp.makeConstraints { make in
            make.centerY.equalTo(saturdayProgressView.snp.centerY)
            make.centerX.equalTo(mondayTitle.snp.centerX)
        }
        saturdayTitle.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        
        sundayTitle.snp.makeConstraints { make in
            make.centerY.equalTo(sundayProgressView.snp.centerY)
            make.centerX.equalTo(mondayTitle.snp.centerX)
        }
        sundayTitle.transform = CGAffineTransform(rotationAngle: (.pi / 2))
    }

    /// Set ProgressImage
    private func setProgressImage(view: UIProgressView) -> UIImage? {
        return UIImage(bounds: view.frame, colors: [UIColor.gradient1, UIColor.OnOffMain])
    }
    
    /// Input Data
    func inputData(statistics: DayStatistics) {
        mondayProgressView.progress = statistics.monday ?? 0
        mondayProgressView.progressImage = setProgressImage(view: mondayProgressView)
        
        tuesdayProgressView.progress = statistics.tuesday ?? 0
        tuesdayProgressView.progressImage = setProgressImage(view: tuesdayProgressView)
        
        wednesdayProgressView.progress = statistics.wendseday ?? 0
        wednesdayProgressView.progressImage = setProgressImage(view: wednesdayProgressView)
        
        thursdayProgressView.progress = statistics.thursday ?? 0
        thursdayProgressView.progressImage = setProgressImage(view: thursdayProgressView)
        
        fridayProgressView.progress = statistics.friday ?? 0
        fridayProgressView.progressImage = setProgressImage(view: fridayProgressView)
        
        saturdayProgressView.progress = statistics.saturday ?? 0
        saturdayProgressView.progressImage = setProgressImage(view: saturdayProgressView)
        
        sundayProgressView.progress = statistics.sunday ?? 0
        sundayProgressView.progressImage = setProgressImage(view: sundayProgressView)
    }
}
