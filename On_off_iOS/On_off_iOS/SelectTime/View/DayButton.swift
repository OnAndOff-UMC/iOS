//
//  DayButton.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/18.
//

import RxSwift
import RxCocoa
import UIKit

final class DayButton: UIButton {
    var disposeBag = DisposeBag()

    var dayModel: DayModel = DayModel(name: "", isChecked: false) {
        didSet {
            self.setTitle(dayModel.name, for: .normal)
            updateUI()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// setupUI
    private func setupUI() {
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.lightGray
        self.setTitleColor(.white, for: .normal)
    }

    /// 버튼 클릭 bind
    private func setupBinding() {
        self.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                dayModel.isChecked.toggle()
                updateUI()
            }
            .disposed(by: disposeBag)
    }

    /// 버튼 클릭시 토글적용 업데이트
    private func updateUI() {
        self.backgroundColor = dayModel.isChecked ? UIColor.purple : UIColor.lightGray
    }
}
