//
//  ModalEmoticonViewController.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/02/02.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

final class ModalEmoticonViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var onImageSelected: ((String) -> Void)?
    /// 더미 이미지
    private var emoticons: [Emoticon] = (1...30).map { id in
        Emoticon(id: id, imageUrl: "https://onnoff-dev-s3.s3.ap-northeast-2.amazonaws.com/0d23ee61-810a-4cc6-8bf9-a10f424d002f.png")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(EmoticonCollectionViewCell.self,
                                forCellWithReuseIdentifier: CellIdentifier.EmoticonCollectionViewCell.rawValue)
        collectionView.delegate = self

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindCollectionView()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
    }
    
    private func bindCollectionView() {
        
        Observable.just(emoticons)
            .bind(to: collectionView.rx.items(cellIdentifier: CellIdentifier.EmoticonCollectionViewCell.rawValue, cellType: EmoticonCollectionViewCell.self)) { row, emoticon, cell in
                cell.configure(with: emoticon.imageUrl)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Emoticon.self)
               .subscribe(onNext: { [weak self] emoticon in
                   self?.onImageSelected?(emoticon.imageUrl)
                   self?.dismiss(animated: true, completion: nil)
               })
               .disposed(by: disposeBag)
    }
}

/// extension UICollectionViewDelegateFlowLayout
extension ModalEmoticonViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 한 줄에 5개의 이미지가 들어가도록 계산
        let width = collectionView.frame.width / 5 - 20
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

