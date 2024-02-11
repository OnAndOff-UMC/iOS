//
//  BigImageController.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/11/24.
//

import Foundation
import SnapKit
import RxCocoa
import RxSwift
import UIKit

/// 이미지 크게 보이는 화면
final class WatchPictureController: UIViewController {
    
    /// 네비게이션 오른쪽 버튼
    private lazy var navigationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trash")?.resize(newWidth: 20), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    /// 선택한 이미지 크게 보기
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 선택 이미지
    var clickedImageButtons: String?
    private let disposeBag = DisposeBag()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationButton)
        
        addSubViews()
        inputSelectedImage()
    }
    
    /// Add SubView
    private func addSubViews() {
        view.addSubview(imageView)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    /// 선택한 이미지 넣기
    private func inputSelectedImage() {
        // TODO: 이미지 로딩 해야함
        imageView.image = UIImage(named: clickedImageButtons ?? "")
    }
}
