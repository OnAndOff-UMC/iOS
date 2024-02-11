//
//  ImageCollectionViewCell.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/11/24.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

/// Off 화면에서 Image 선택
final class ImageCollectionViewCell: UICollectionViewCell {
    
    /// 선택한 이미지
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
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
        contentView.addSubview(imageView)
        
        constriants()
    }
    
    /// Constraints
    private func constriants() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// Input Data
    /// - Parameter imageURL: 이미지 URL주소
    func inputData(imageURL: Image) {
        print("imageURL \(imageURL)")
    }
    
    /// 마지막 이미지 추가 버튼
    /// - Parameter image: 이미지 plus 버튼
    func lastData(image: Image) {
        imageView.image = UIImage(systemName: image.imageUrl ?? "")?
            .withTintColor(.OnOffLightPurple)
            .resize(newWidth: 30)
    }
}
