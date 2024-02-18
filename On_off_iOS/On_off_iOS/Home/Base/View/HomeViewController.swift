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
import Mantis
import Photos

final class HomeViewController: UIViewController {
    
    /// Safe Area Top Layout UIView
    private lazy var safeAreaTopUIView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// On - Off Button
    private lazy var onOffButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    /// Title Label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 24)
        label.backgroundColor = .clear
        return label
    }()
    
    /// On - Off 에 따른 이미지 뷰
    private lazy var dayImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        return view
    }()
    
    /// 현재 달, 연도
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .purple
        label.backgroundColor = .clear
        return label
    }()
    
    /// 이전 주로 가는 버튼
    private lazy var prevButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "lessthan")?.withTintColor(.white), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    /// 다음주로 가는 버튼
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "greaterthan")?.withTintColor(.white), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    /// "일" 스크롤 뷰
    private lazy var dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.allowsMultipleSelection = false
        view.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier.DayCollectionViewCell.rawValue)
        return view
    }()
    
    /// On UIView
    private lazy var onUIView: OnUIView = {
        let view = OnUIView(frame: CGRect(x: .zero, y: .zero, width: view.safeAreaLayoutGuide.layoutFrame.width, height: .zero))
        view.backgroundColor = .white
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 25
        
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowOpacity = 0.5
        
        return view
    }()
    
    /// Off UIView
    private lazy var offUIView: OffUIView = {
        let view = OffUIView(frame: CGRect(x: .zero, y: .zero, width: view.safeAreaLayoutGuide.layoutFrame.width, height: .zero))
        view.backgroundColor = .white
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 25
        
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowOpacity = 0.5
        
        return view
    }()
    
    /// 미래로 간 뷰
    private lazy var futureUIView: FutureUIView = {
        let view = FutureUIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 25
        
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ViewModel을 통해 선택된 날짜를 가져와 설정
        if let selectedDate = viewModel.getSelectedDateAsString() {
            offUIView.selectedDate.onNext(selectedDate)
        }
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBaseSubViews()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        onUIView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0,
                                                              width: onUIView.frame.width,
                                                              height: onUIView.frame.height - 50)).cgPath
        
    }
    
    /// On - Off 공통 UI Add View
    private func addBaseSubViews() {
        view.addSubview(safeAreaTopUIView)
        view.addSubview(onOffButton)
        view.addSubview(titleLabel)
        view.addSubview(dayImageView)
        view.addSubview(monthLabel)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        view.addSubview(dayCollectionView)
        
        baseConstraints()
    }
    
    /// On - Off 공통 UI Constraints
    private func baseConstraints() {
        onOffButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        safeAreaTopUIView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(onOffButton.snp.top)
            make.height.equalTo(200)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        prevButton.snp.makeConstraints { make in
            make.bottom.equalTo(dayCollectionView.snp.top).offset(-10)
            make.trailing.equalTo(nextButton.snp.leading).offset(-20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(dayCollectionView.snp.top).offset(-10)
            make.trailing.equalTo(dayCollectionView.snp.trailing).offset(-10)
        }
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-6)
            make.height.equalTo(70)
        }
    }
    
    /// Off  UI Add View
    private func addOffSubViews() {
        view.addSubview(offUIView)
        
        offConstraints()
    }
    
    /// Off UI Constraints
    private func offConstraints() {
        offUIView.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// Future  UI Add View
    private func addFutureSubViews() {
        view.addSubview(futureUIView)
        
        futureConstraints()
    }
    
    /// Future UI Constraints
    private func futureConstraints() {
        futureUIView.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// On  UI Add View
    private func addOnSubViews() {
        view.addSubview(onUIView)
        
        onConstraints()
    }
    
    /// On UI Constraints
    private func onConstraints() {
        onUIView.snp.makeConstraints { make in
            make.top.equalTo(dayCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// Binding
    private func bind() {
        let input = HomeViewModel.Input(onOffButtonEvents: onOffButton.rx.tap,
                                        dayCollectionViewEvents: dayCollectionView.rx.itemSelected,
                                        prevButtonEvents: prevButton.rx.tap,
                                        nextButtonEvents: nextButton.rx.tap,
                                        moveStartToWriteViewControllerEvents: offUIView.moveStartToWriteViewController)
        let output = viewModel.createOutput(input: input)
        
        bindDayCollectionView(output: output)
        bindDayCollectionViewSelectedCell(output: output)
        bindMonthLabel(output: output)
        bindTitleLabel(output: output)
        bindDayImageView(output: output)
        bindOnOffButton(output: output)
        bindBackGroundColor(output: output)
        bindBlankViewShadowColor(output: output)
        bindToggleOnOffButton(output: output)
        bindFutureRelay(output: output)
        bindClickImagePlusButton()
        bindClickImageButton()
        bindAddWorkLifeBalanceFeedButton()
        bindSelectedFeedTableViewCell()
        bindCheckToday(output: output)
        bindMoveInquireMemoirsViewController()
        bindAddWorkLogButton()
        bindSelectedWorklogTableViewCell()
    }
    
    /// Binding Day CollectionView Cell
    private func bindDayCollectionView(output: HomeViewModel.Output) {
        output.dayListRelay
            .bind(to: dayCollectionView.rx
                .items(cellIdentifier: CellIdentifier.DayCollectionViewCell.rawValue,
                       cellType: DayCollectionViewCell.self))
        { row, element, cell in
            cell.backgroundColor = .clear
            cell.inputData(info: element,
                           color: output.dayCollectionViewBackgroundColorRelay.value,
                           textColor: output.dayCollectionTextColorRelay.value)
            
            if row == output.selectedDayIndex.value.row {
                cell.selectedEffect(color: output.selectedDayCollectionViewBackgroundColorRelay.value,
                                    textColor: output.selectedDayCollectionTextColorRelay.value)
            }
        }
        .disposed(by: disposeBag)
        
        dayCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    /// Bind Day CollectionView Selected Cell
    private func bindDayCollectionViewSelectedCell(output: HomeViewModel.Output) {
        dayCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self,
                      let cell = dayCollectionView.cellForItem(at: output.selectedDayIndex.value) as? DayCollectionViewCell,
                      let selectedCell = dayCollectionView.cellForItem(at: indexPath) as? DayCollectionViewCell else { return }
                cell.selectedEffect(color: output.dayCollectionViewBackgroundColorRelay.value,
                                    textColor: output.dayCollectionTextColorRelay.value)
                selectedCell.selectedEffect(color: output.selectedDayCollectionViewBackgroundColorRelay.value,
                                            textColor: output.selectedDayCollectionTextColorRelay.value)
                output.selectedDayIndex.accept(indexPath)
                offUIView.selectedDate.onNext(output.dayListRelay.value[output.selectedDayIndex.value.row].totalDate ?? "")
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Month Label
    private func bindMonthLabel(output: HomeViewModel.Output) {
        output.monthRelay
            .bind { [weak self] month in
                guard let self = self else { return }
                monthLabel.attributedText = month
                dayCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Title Label
    private func bindTitleLabel(output: HomeViewModel.Output) {
        output.titleRelay
            .bind { [weak self] title in
                guard let self = self else { return }
                titleLabel.attributedText = title
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Day Image View
    private func bindDayImageView(output: HomeViewModel.Output) {
        output.dayImageRelay
            .bind(to: dayImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    /// Binding On Off Button
    private func bindOnOffButton(output: HomeViewModel.Output) {
        output.buttonOnOffRelay
            .bind { [weak self] image in
                guard let self = self else { return }
                onOffButton.setImage(image?.resize(newWidth: 50), for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding BackGround Color
    private func bindBackGroundColor(output: HomeViewModel.Output) {
        output.backgroundColorRelay
            .bind { [weak self] color in
                guard let self = self else { return }
                view.backgroundColor = color
                safeAreaTopUIView.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding BlankView Shadow Color
    private func bindBlankViewShadowColor(output: HomeViewModel.Output) {
        output.blankUIViewShadowColorRelay
            .bind { [weak self] color in
                guard let self = self else { return }
                onUIView.layer.shadowColor = color.cgColor
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding toggle On - Off Button
    private func bindToggleOnOffButton(output: HomeViewModel.Output) {
        output.toggleOnOffButtonRelay
            .bind { [weak self] check in
                guard let self = self else { return }
                if check && !output.futureRelay.value {
                    offUIView.removeFromSuperview()
                    addOnSubViews()
                } else if !output.futureRelay.value {
                    onUIView.removeFromSuperview()
                    addOffSubViews()
                    print("👍\(output.dayListRelay.value[output.selectedDayIndex.value.row])")
                    offUIView.selectedDate.onNext(output.dayListRelay.value[output.selectedDayIndex.value.row].totalDate ?? "")
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// Bind Future Relay
    private func bindFutureRelay(output: HomeViewModel.Output) {
        output.futureRelay
            .bind { [weak self] check in
                guard let self = self else { return }
                if check {  // 미래날짜로 갔을 때
                    onUIView.removeFromSuperview()
                    offUIView.removeFromSuperview()
                    addFutureSubViews()
                    onOffButton.isEnabled = false
                    output.toggleOnOffButtonRelay.accept(true)
                    return
                }
                futureUIView.removeFromSuperview()
                addOnSubViews()
                onOffButton.isEnabled = true
                output.toggleOnOffButtonRelay.accept(true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 이미지 추가버튼 눌렀을 때
    /// 이미지 선택하는 화면으로 이동
    private func bindClickImagePlusButton() {
        offUIView.clickedImagePlusButton
            .bind { [weak self] in
                guard let self = self else { return }
                authPhotoLibrary(self) { [weak self] in
                    guard let self = self else { return }
                    
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    imagePickerController.allowsEditing = false // 이미지 편집 기능 On
                    
                    present(imagePickerController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// 이미지 선택했을 때
    /// 이미지 크게 보는 화면으로 이동
    private func bindClickImageButton() {
        offUIView.clickedImageButton
            .bind { [weak self] imageURL in
                guard let self = self else { return }
                let watchPictureController = WatchPictureController()
                watchPictureController.clickedImageButtons = imageURL
                navigationController?.pushViewController(watchPictureController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 업무일지 피드 추가 버튼
    private func bindAddWorkLogButton() {
        onUIView.clickedAddWorklogButton
            .bind { [weak self] in
                guard let self = self else { return }
                presentInsertWorkLogView(insertFeed: nil)
            }
            .disposed(by: disposeBag)
    }
    
    /// 워라벨 피드 추가 버튼
    private func bindAddWorkLifeBalanceFeedButton() {
        offUIView.clickedAddfeedButton
            .bind { [weak self] in
                guard let self = self else { return }
                presentInsertWLBFeedView(insertFeed: nil)
            }
            .disposed(by: disposeBag)
    }
    
    /// 업무일지 클릭한 경우
    /// Worklog 클릭한 경우
    private func bindSelectedWorklogTableViewCell() {
        onUIView.selectedWorklogTableViewCell
            .bind { [weak self] Worklog in
                guard let self = self else { return }
                let ClickWorklogView = ClickWorklogView()
                ClickWorklogView.feedSubject.onNext(Worklog)
                ClickWorklogView.successConnect
                    .bind { [weak self] in
                        guard let self = self else { return }
                        OnUIView().successAddWorklog.onNext(())
                    }
                    .disposed(by: disposeBag)
                
                ClickWorklogView.insertFeedSubject
                    .bind { [weak self] feed in
                        guard let self = self else { return }
                        presentInsertWorkLogView(insertFeed: feed)
                    }
                    .disposed(by: disposeBag)
                present(ClickWorklogView, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
    /// 워라벨 피드 클릭한 경우
    private func bindSelectedFeedTableViewCell() {
        offUIView.selectedFeedTableViewCell
            .bind { [weak self] feed in
                guard let self = self else { return }
                let clickWorkLifeBalanceFeedView = ClickWorkLifeBalanceFeedView()
                clickWorkLifeBalanceFeedView.feedSubject.onNext(feed)
                clickWorkLifeBalanceFeedView.successConnect
                    .bind { [weak self] in
                        guard let self = self else { return }
                        offUIView.successAddFeed.onNext(())
                    }
                    .disposed(by: disposeBag)
                
                clickWorkLifeBalanceFeedView.insertFeedSubject
                    .bind { [weak self] feed in
                        guard let self = self else { return }
                        presentInsertWLBFeedView(insertFeed: feed)
                    }
                    .disposed(by: disposeBag)
                present(clickWorkLifeBalanceFeedView, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Move Start To Write View Controller
    private func bindCheckToday(output: HomeViewModel.Output) {
        output.checkToday
            .bind { [weak self] check in
                guard let self = self else { return }
                if check { // 오늘 날짜
                    let startToWriteViewController = StartToWriteViewController(viewModel: StartToWriteViewModel())
                    navigationController?.pushViewController(startToWriteViewController, animated: true)
                    return
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Move Inquire Memoirs ViewController
    private func bindMoveInquireMemoirsViewController() {
        offUIView.moveInquireMemoirsViewController
            .bind { [weak self] date in
                guard let self = self else { return }
                let inquireMemoirsViewController = InquireMemoirsViewController(viewModel: InquireMemoirsViewModel())
                inquireMemoirsViewController.todayDate = date
                navigationController?.pushViewController(inquireMemoirsViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Present Insert W.L.B Feed View
    private func presentInsertWLBFeedView(insertFeed: Feed?) {
        let insertWorkLifeBalanceFeedView = InsertWorkLifeBalanceFeedView()
        if let insertFeed = insertFeed {
            insertWorkLifeBalanceFeedView.insertFeed.onNext(insertFeed)
        }
        insertWorkLifeBalanceFeedView.successAddFeedSubject
            .bind { [weak self] in
                guard let self = self else { return }
                offUIView.successAddFeed.onNext(())
            }
            .disposed(by: disposeBag)
        present(insertWorkLifeBalanceFeedView, animated: true)
    }
    
    /// presentInsertWorkLogView
    private func presentInsertWorkLogView(insertFeed: Worklog?) {
        let InsertWorkLogView = InsertWorkLogView()
        if let insertFeed = insertFeed {
            InsertWorkLogView.insertFeed.onNext(insertFeed)
        }
        InsertWorkLogView.successAddWorklogSubject
            .bind { [weak self] in
                guard let self = self else { return }
                OnUIView().successAddWorklog.onNext(())
            }
            .disposed(by: disposeBag)
        present(InsertWorkLogView, animated: true)
    }
    
    
    /// 사진 접근 권한 설정
    private func photoAuth(isCamera: Bool, viewController: UIViewController, completion: @escaping () -> ()) {
        
        // 경고 메시지 작성
        let sourceName = isCamera ? "카메라" : "사진 라이브러리"
        
        let notDeterminedAlertTitle = "No Permission Status"
        let notDeterminedMsg = "\(sourceName)의 권한 설정을 변경하시겠습니까?"
        
        let restrictedMsg = "시스템에 의해 거부되었습니다."
        
        let deniedAlertTitle = "Permission Denied"
        let deniedMsg = "\(sourceName)의 사용 권한이 거부되었기 때문에 사용할 수 없습니다. \(sourceName)의 권한 설정을 변경하시겠습니까?"
        
        let unknownMsg = "unknown"
        
        // 카메라인 경우와 사진 라이브러리인 경우를 구분해서 권한 status의 원시값(Int)을 저장
        let status: Int = isCamera ? AVCaptureDevice.authorizationStatus(for: AVMediaType.video).rawValue : PHPhotoLibrary.authorizationStatus().rawValue
        
        // PHAuthorizationStatus, AVAuthorizationStatus의 status의 원시값은 공유되므로 같은 switch문에서 사용
        switch status {
        case 0:
            // .notDetermined - 사용자가 아직 권한에 대한 설정을 하지 않았을 때
            simpleDestructiveYesAndNo(viewController, message: notDeterminedMsg, title: notDeterminedAlertTitle, yesHandler: openSettings)
            print("CALLBACK FAILED: \(sourceName) is .notDetermined")
        case 1:
            // .restricted - 시스템에 의해 앨범에 접근 불가능하고, 권한 변경이 불가능한 상태
            simpleAlert(viewController, message: restrictedMsg)
            print("CALLBACK FAILED: \(sourceName) is .restricted")
        case 2:
            // .denied - 접근이 거부된 경우
            simpleDestructiveYesAndNo(viewController, message: deniedMsg, title: deniedAlertTitle, yesHandler: openSettings)
            print("CALLBACK FAILED: \(sourceName) is .denied")
        case 3:
            // .authorized - 권한 허용된 상태
            print("CALLBACK SUCCESS: \(sourceName) is .authorized")
            completion()
        case 4:
            // .limited (iOS 14 이상 사진 라이브러리 전용) - 갤러리의 접근이 선택한 사진만 허용된 경우
            print("CALLBACK SUCCESS: \(sourceName) is .limited")
            completion()
        default:
            // 그 외의 경우 - 미래에 새로운 권한 추가에 대비
            simpleAlert(viewController, message: unknownMsg)
            print("CALLBACK FAILED: \(sourceName) is unknwon state.")
        }
    }
    
    /// 설정 앱 열기
    private func openSettings(action: UIAlertAction) -> Void {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    /// photoAuth 함수를 main 스레드에서 실행 (UI 관련 문제 방지)
    private func photoAuthInMainAsync(isCamera: Bool, viewController: UIViewController, completion: @escaping () -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            photoAuth(isCamera: isCamera, viewController: viewController, completion: completion)
        }
    }
    
    /// 사진 라이브러리의 권한을 묻고, 이후 () -> () 클로저를 실행하는 함수
    private func authPhotoLibrary(_ viewController: UIViewController, completion: @escaping () -> ()) {
        if #available(iOS 14, *) {
            // iOS 14의 경우 사진 라이브러리를 읽기전용 또는 쓰기가능 형태로 설정해야 함
            PHPhotoLibrary.requestAuthorization(for: .readWrite) {  [weak self] status in
                guard let self = self else { return }
                photoAuthInMainAsync(isCamera: false, viewController: viewController, completion: completion)
            }
        } else {
            // Fallback on earlier versions
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                photoAuthInMainAsync(isCamera: false, viewController: viewController, completion: completion)
            }
        }
    }
    
    // MARK: - 권한별 Alert
    private func simpleAlert(_ controller: UIViewController, message: String) {
        let alertController = UIAlertController(title: "Caution", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    private func simpleAlert(_ controller: UIViewController, message: String, title: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(alertAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    private func simpleDestructiveYesAndNo(_ controller: UIViewController, message: String, title: String, yesHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let alertActionYes = UIAlertAction(title: "Yes", style: .destructive, handler: yesHandler)
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionYes)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    private func simpleYesAndNo(_ controller: UIViewController, message: String, title: String, yesHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let alertActionYes = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionYes)
        controller.present(alertController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interval: CGFloat = 10
        let width: CGFloat = (collectionView.frame.width - interval * 2) / 8
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
}

extension HomeViewController: UIImagePickerControllerDelegate, CropViewControllerDelegate, UINavigationControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        print(cropped, #function)
        offUIView.selectedImage.onNext(cropped)
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }
    
    /// 사진 편집 하는 기능 열기
    private func openCropVC(image: UIImage) {
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1/1)
        present(cropViewController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: false) { [weak self] in
                guard let self = self else { return }
                openCropVC(image: image)
            }
            
        }
        dismiss(animated: false)
        
    }
}
