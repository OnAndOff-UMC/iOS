//
//  DeletedMemoirsPopUpView.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/14.
//

import Foundation
import UIKit
import RxSwift

final class DeletedMemoirsPopUpView: DimmedViewController {
    
    /// 배경 뷰
    private lazy var baseUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// 제목 라벨
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회고 기록 삭제"
        label.textColor = .OnOffMain
        label.font = .pretendard(size: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 구분 선
    private lazy var divideLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .OnOffMain
        return view
    }()
    
    /// 설명 라벨 1
    private lazy var descriptionLabel1: UILabel = {
        let label = UILabel()
        label.text = "2023년 11월 22일에 기록한 회고를"
        label.textColor = .black
        label.font = .pretendard(size: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 설명 라벨 2
    private lazy var descriptionLabel2: UILabel = {
        let label = UILabel()
        label.text = "삭제하시겠어요?"
        label.textColor = .black
        label.font = .pretendard(size: 18, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    /// 취소 버튼
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.OnOffMain.cgColor
        button.layer.borderWidth = 1
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.OnOffMain, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        button.layer.cornerRadius = 15
        return button
    }()
    
    /// 삭제 버튼
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .OnOffMain
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .bold)
        button.layer.cornerRadius = 15
        return button
    }()
    
    /// 버튼들 담을 스택 뷰
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cancelButton, deleteButton])
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private let navigationControllers: UINavigationController
    private let viewModel = DeletedMemoirsPopUpViewModel()
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationControllers = navigationController
        super.init(durationTime: 0.3, alpha: 0.7)
        addSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Add Subviews
    private func addSubviews() {
        view.addSubview(baseUIView)
        baseUIView.addSubview(titleLabel)
        baseUIView.addSubview(divideLineView)
        baseUIView.addSubview(descriptionLabel1)
        baseUIView.addSubview(descriptionLabel2)
        baseUIView.addSubview(buttonStackView)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        baseUIView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        divideLineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        descriptionLabel1.snp.makeConstraints { make in
            make.top.equalTo(divideLineView.snp.bottom).offset(55)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel2.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel1.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel2.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(-25)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    /// Binding
    private func bind() {
        let input = DeletedMemoirsPopUpViewModel.Input(clickDeleteButtonEvents: deleteButton.rx.tap)
        
        let output = viewModel.createOutput(input: input)
        
        output.successDeleteSubject
              .subscribe(onNext: { [weak self] isSuccess in
                  if isSuccess {
                      // 삭제 성공 시, 처리 로직
                      print("회고록 삭제 성공")
                      self?.dismiss(animated: true, completion: nil)
                  } else {
                      // 삭제 실패 시, 처리 로직
                      print("회고록 삭제 실패")
                  }
              })
              .disposed(by: disposeBag)
        bindSuccessDeleteSubject(output: output)
        bindCancelButton()
    }
    
    /// Bind Cancel Button
    private func bindCancelButton() {
        cancelButton.rx.tap
            .bind { [weak self]  in
                guard let self = self else { return }
                dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding 삭제 성공 했을 때
    private func bindSuccessDeleteSubject(output: DeletedMemoirsPopUpViewModel.Output) {
        output.successDeleteSubject
            .bind { [weak self] check in
                guard let self = self else { return }
                if check {
                    dismiss(animated: true) { [weak self]  in
                        guard let self = self else { return }
                        navigationControllers.popViewController(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

