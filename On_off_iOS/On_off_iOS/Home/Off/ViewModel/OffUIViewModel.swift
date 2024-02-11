//
//  OffUIViewModel.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit
import SnapKit

final class OffUIViewModel {
    private let disposeBag = DisposeBag()
    private let service = OffUIViewService()
    
    struct Input {
        let todayMemoirsButtonEvents: ControlEvent<Void>?
        let todayMemoirsIconImageButtonEvents: ControlEvent<Void>?
        let feedTitleButtonEvents: ControlEvent<Void>?
        let feedPlusIconImageButtonEvents: ControlEvent<Void>?
        let collectionViewCellEvents: ControlEvent<IndexPath>?
        let selectedImage: Observable<UIImage>?
    }
    
    struct Output {
        var imageURLRelay: BehaviorRelay<[Image]> = BehaviorRelay(value: [])
        var clickPlusImageButton: BehaviorSubject<Void> = BehaviorSubject(value: ())
        var checkUploadImageRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var heightConstraint: BehaviorRelay<Constraint?> = BehaviorRelay(value: nil)
        var selectedImageRelay: BehaviorRelay<Image?> = BehaviorRelay(value: nil)
    }
    
    /// Create Output
    /// - Parameter input: Input
    /// - Returns: Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindTodayMemoirsEvents(input: input, output: output)
        bindFeedEvents(input: input, output: output)
        bindClickedCollectoinViewCell(input: input, output: output)
        bindSelectedCroppedImage(input: input, output: output)
        
        getImageList(output: output)
        return output
    }
    
    /// 오늘의 회고 제목 버튼 및 이미지 버튼
    private func bindTodayMemoirsEvents(input: Input, output: Output) {
        input.todayMemoirsButtonEvents?
            .bind {
                print("tap todayMemoirsButtonEvents")
            }
            .disposed(by: disposeBag)
        
        input.todayMemoirsIconImageButtonEvents?
            .bind {
                print("tap todayMemoirsIconImageButtonEvents")
            }
            .disposed(by: disposeBag)
    }
    
    /// 워라벨 피드 제목 버튼 및 이미지 버튼
    private func bindFeedEvents(input: Input, output: Output) {
        input.feedTitleButtonEvents?
            .bind {
                print("tap feedTitleButton")
            }
            .disposed(by: disposeBag)
        
        input.feedPlusIconImageButtonEvents?
            .bind {
                print("tap feedPlusIconImageButton")
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Clicked CollectionView Cell
    private func bindClickedCollectoinViewCell(input: Input, output: Output) {
        input.collectionViewCellEvents?
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                print(indexPath, output.imageURLRelay.value[indexPath.row])
                
                if indexPath.row == output.imageURLRelay.value.count - 1 {
                    clickPlusImageButton(output: output)
                    return
                }
                clickImageButton(output: output, indexPath: indexPath)
            }
            .disposed(by: disposeBag)
    }
    
    /// 선택된 이미지 업로드
    private func bindSelectedCroppedImage(input: Input, output: Output) {
        input.selectedImage?
            .bind { [weak self] image in
                guard let self = self else { return }
                uploadImage(image: image, output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// 이미지 추가 버튼 눌렀을 때
    private func clickPlusImageButton(output: Output) {
        output.clickPlusImageButton.onNext(())
    }
    
    /// 로딩된 이미지 눌렀을 때
    private func clickImageButton(output: Output, indexPath: IndexPath) {
        output.selectedImageRelay.accept(output.imageURLRelay.value[indexPath.row])
    }
    
    /// get ImageList Data
    private func getImageList(output: Output) {
        service.getImageList()
            .subscribe(onNext: { list in
                var list: [Image] = list
                list.append(Image(feedImageId: nil, imageUrl: "plus.circle.fill"))
                output.imageURLRelay.accept(list)
                
            }, onError: { error in
                print(error)
                output.imageURLRelay.accept([Image(feedImageId: nil, imageUrl: "plus.circle.fill")])
            })
            .disposed(by: disposeBag)
        
    }
    
    
    /// Upload Image
    /// - Parameters:
    ///   - image: 선택한 이미지
    private func uploadImage(image: UIImage, output: Output) {
        service.uploadImage(image: image)
            .subscribe(onNext: { [weak self] check in
                guard let self = self else { return }
                if check {
                    print("called getImageList")
                    getImageList(output: output)
                }
            }, onError: { error in
                // 업로드 실패
            })
            .disposed(by: disposeBag)
    }
}
