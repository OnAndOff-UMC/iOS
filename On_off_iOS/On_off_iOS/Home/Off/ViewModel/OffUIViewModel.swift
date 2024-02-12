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
        let collectionViewCellEvents: ControlEvent<IndexPath>?
        let selectedImage: Observable<UIImage>?
        let successDeleteImage: Observable<Void>?
        let loadWLBFeed: Observable<Void>?
        let clickCheckMarkOfWLBFeed: Observable<Feed>?
        let selectedDate: Observable<String>?
        let successAddFeed: Observable<Void>?
    }
    
    struct Output {
        var imageURLRelay: BehaviorRelay<[Image]> = BehaviorRelay(value: [])
        var clickPlusImageButton: BehaviorSubject<Void> = BehaviorSubject(value: ())
        var checkUploadImageRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var collectionViewHeightConstraint: BehaviorRelay<Constraint?> = BehaviorRelay(value: nil)
        var tableViewHeightConstraint: BehaviorRelay<Constraint?> = BehaviorRelay(value: nil)
        var selectedImageRelay: BehaviorRelay<Image?> = BehaviorRelay(value: nil)
        var workLifeBalanceRelay: BehaviorRelay<[Feed]> = BehaviorRelay(value: [])
        var successCheckWLBRelay: PublishRelay<Bool> = PublishRelay()
        var selectedDate: BehaviorRelay<String> = BehaviorRelay(value: "")
    }
    
    /// Create Output
    /// - Parameter input: Input
    /// - Returns: Output
    func createOutput(input: Input) -> Output {
        let output = Output()
        
        bindTodayMemoirsEvents(input: input, output: output)
        bindClickedCollectoinViewCell(input: input, output: output)
        bindSelectedCroppedImage(input: input, output: output)
        bindSuccessDeleteImageEvents(input: input, output: output)
        bindSelectedWLBFeed(input: input, output: output)
        bindLoadWLBFeed(input: input, output: output)
        bindSelectedDate(input: input, output: output)
        bindSuccessAddFeed(input: input, output: output)
        
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
    
    /// Bind When Success Delete Image Events
    private func bindSuccessDeleteImageEvents(input: Input, output: Output) {
        input.successDeleteImage?
            .bind { [weak self] in
                guard let self = self else { return }
                getImageList(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Load W.L.B Feed
    private func bindLoadWLBFeed(input: Input, output: Output) {
        input.loadWLBFeed?
            .bind {  [weak self] in
                guard let self = self else { return }
                getWorkLifeBalanceList(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Selected Date
    private func bindSelectedDate(input: Input, output: Output) {
        input.selectedDate?
            .bind(to: output.selectedDate)
            .disposed(by: disposeBag)
    }
    
    /// Binding Success Add Feed
    private func bindSuccessAddFeed(input: Input, output: Output) {
        input.successAddFeed?
            .bind {  [weak self] in
                guard let self = self else { return }
                getWorkLifeBalanceList(output: output)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Selected W.L.B Feed
    private func bindSelectedWLBFeed(input: Input, output: Output) {
        input.clickCheckMarkOfWLBFeed?
            .bind { [weak self] feed in
                guard let self = self, let id = feed.feedId else { return }
                checkWLBFeed(feedId: id, input: input, output: output)
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
    
    /// Format Date To String
    /// - Parameter date: Date
    /// - Returns: String Type Date
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
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
    
    /// Get WorkLifeBalance List
    /// - Parameters:
    ///   - selectedDate: Selected Date
    private func getWorkLifeBalanceList(output: Output) {
        service.getWLBFeedList(date: output.selectedDate.value)
            .subscribe(onNext: { list in
                output.workLifeBalanceRelay.accept(list)
            }, onError: { error in
                // 업로드 실패
                print(#function, error)
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
    
    
    /// 워라벨 피드 체크 유무
    /// - Parameters:
    ///   - feedId: Feed Id
    ///   - output: Output
    private func checkWLBFeed(feedId: Int, input: Input, output: Output) {
        service.checkWLBFeed(feedId: feedId)
            .subscribe(onNext: { [weak self] check in
                guard let self = self else { return }
                if check {
                    output.successCheckWLBRelay.accept(check)
                    getWorkLifeBalanceList(output: output)
                }
            }, onError:  { error in
                print(#function, error)
            })
            .disposed(by: disposeBag)
    }
}
