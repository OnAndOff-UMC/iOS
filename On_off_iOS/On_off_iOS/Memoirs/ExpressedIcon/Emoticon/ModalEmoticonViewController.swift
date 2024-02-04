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
    private let memoirsService = MemoirsService()
    
    var onImageSelected: ((String) -> Void)?

    /// imageView collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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
        fetchEmoticonsAndBindToCollectionView()
    }

    /// setupViews
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    /// setupConstraints
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
    } 
    
    private func fetchEmoticonsAndBindToCollectionView() {
        memoirsService.getEmoticon()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] emoticonResponse in
                guard let self = self else { return }
                bindEmoticonsToCollectionView(emoticons: emoticonResponse.result)
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    private func bindEmoticonsToCollectionView(emoticons: [Emoticon]) {
        
        Observable.just(emoticons)
            .bind(to: collectionView.rx.items(cellIdentifier: CellIdentifier.EmoticonCollectionViewCell.rawValue, cellType: EmoticonCollectionViewCell.self)) { index, emoticon, cell in
                cell.configure(with: emoticon.imageUrl)
            }.disposed(by: disposeBag)

        collectionView.rx.modelSelected(Emoticon.self)
            .subscribe(onNext: { [weak self] emoticon in
                print("선택된 emoticon: \(emoticon.emoticonId), URL: \(emoticon.imageUrl)")
                self?.onImageSelected?(emoticon.imageUrl)
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}

/// extension UICollectionViewDelegateFlowLayout
extension ModalEmoticonViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 한 줄에 3개의 이미지가 들어가도록 너비 계산
        let paddingSpace = 10 * (3 - 1)
        let availableWidth = collectionView.frame.width - CGFloat(paddingSpace) - collectionView.contentInset.left - collectionView.contentInset.right
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: widthPerItem)
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
