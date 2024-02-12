//
//  ModalMenuOptionViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/12.
//

import Foundation
import UIKit

final class ModalMenuOptionViewController: UIViewController {
    
    private lazy var reviceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "수정하기"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .OnOffMain
        return lineView
    }()
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "삭제하기"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        setupViews()
        self.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 200)

    }
 
    private func settingView(){
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        view.addSubview(reviceLabel)
        view.addSubview(deleteLabel)
        view.addSubview(lineView)
        
        configureConstraints()
    }
    private func configureConstraints() {
        
        reviceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview().offset(10)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(reviceLabel.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        deleteLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.centerX.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(100)
        }
        
    }
}
