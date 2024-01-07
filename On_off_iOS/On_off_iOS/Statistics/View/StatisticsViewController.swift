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
    
    /// Monday
    private lazy var mondayProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.trackTintColor = .blue
        view.progressTintColor = .yellow
        view.setProgress(0.7, animated: true)
        return view
    }()
    
    /// Tuesdays
    private lazy var tuesdaysProgressView: UIProgressView = {
        let view = UIProgressView()
        view.layoutIfNeeded()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.trackTintColor = .red
        view.progressTintColor = .yellow
        view.setProgress(0.4, animated: true)
        return view
    }()
    
    ///
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mondayProgressView, tuesdaysProgressView])
        view.backgroundColor = .clear
        view.distribution = .fillEqually
        view.spacing = 15
        view.axis = .vertical
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
        view.addSubview(stackView)
        
        constraints()
    }
    
    /// Set Constraints
    private func constraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.height.equalTo(stackView.snp.width)
        }
        stackView.transform = CGAffineTransform(rotationAngle: -(.pi / 2)).translatedBy(x: 0, y: 0)
        
    }
    
}
