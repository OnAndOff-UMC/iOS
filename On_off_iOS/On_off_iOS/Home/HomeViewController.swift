//
//  HomeViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/25/24.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    
    /// On, Off Button
    private lazy var onOffButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "on")?.resize(newWidth: 50), for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    /// Title Label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "조디조디조디조디조디님,\n오늘 하루도 파이팅!"
        label.text = "조디조디조디조디조디님,\n오늘 하루도 고생하셨어요"
        label.textColor = .black
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 24)
        label.backgroundColor = .clear
        return label
    }()
    
    /// On-Off 에 따른 이미지 뷰
    private lazy var dayImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "moon"))
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        return view
    }()
    
    /// 현재 달, 연도
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .purple
        label.text = "2023년 11월"
        label.backgroundColor = .clear
        return label
    }()
    
    /// "일" 스크롤 뷰
    private lazy var dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addBaseSubViews()
        bind()
    }
    
    /// On-Off 공통 UI Add View
    private func addBaseSubViews() {
        view.addSubview(onOffButton)
        view.addSubview(titleLabel)
        view.addSubview(dayImageView)
        view.addSubview(monthLabel)
        view.addSubview(dayCollectionView)
        
        baseConstraints()
    }
    
    /// On-Off 공통 UI Constraints
    private func baseConstraints() {
        onOffButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(onOffButton.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        dayImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalTo(titleLabel.snp.trailing).offset(30)
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
    }
    
    /// Binding
    private func bind() {
        let input = HomeViewModel.Input()
        let output = viewModel.createOutput(input: input)
        
        bindingDayCollectionView(output: output)
    }
    
    /// binding Day CollectionView Cell
    private func bindingDayCollectionView(output: HomeViewModel.Output) {
        output.dayListRelay
            .bind(to: dayCollectionView.rx
                .items(cellIdentifier: DayCollectionViewCell.identifier,
                       cellType: DayCollectionViewCell.self))
        { row, element, cell in
            cell.backgroundColor = .clear
            cell.inputData(info: element)
        }
        .disposed(by: disposeBag)
        
        dayCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/7, height: collectionView.frame.height)
    }
}

import SwiftUI
struct VCPreViewHomeViewController:PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview().previewDevice("iPhone 15 Pro")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}

struct VCPreViewHomeViewController2:PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview().previewDevice("iPhone SE (3rd generation)")
        // 실행할 ViewController이름 구분해서 잘 지정하기
    }
}
