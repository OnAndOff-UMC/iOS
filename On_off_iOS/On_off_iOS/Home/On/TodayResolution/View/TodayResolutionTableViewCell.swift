//
//  TodayResolutionTableViewCell.swift
//  On_off_iOS
//
//  Created by 신예진 on 2/18/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

final class TodayResolutionTableViewCell: UITableViewCell {
    /// 제목 라벨
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = .pretendard(size: 17, weight: .medium)
        return label
    }()
    
    /// 체크마크 버튼
    private lazy var checkMarkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "nonCheckMark"), for: .normal)
        return button
    }()
    
    lazy var disposeBag = DisposeBag()
    var checkMarkButtonEvents: Observable<Void> {
        return checkMarkButton.rx.tap.asObservable()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    /// Add SubViews
    private func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkMarkButton)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        checkMarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(checkMarkButton.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkMarkButton.snp.centerY)
            make.leading.equalTo(checkMarkButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }

    /// Input Data
    /// - Parameter Worklog: Worklog
    func inputData(Worklog: WorkGetlogDTO) {
        titleLabel.text = Worklog.content ?? ""
        let image: String = Worklog.isChecked ?? false ? "checkMark" : "nonCheckMark"
        checkMarkButton.setImage(UIImage(named: image), for: .normal)
    }
    

}
