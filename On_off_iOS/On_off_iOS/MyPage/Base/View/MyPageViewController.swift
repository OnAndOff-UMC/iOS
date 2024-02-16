//
//  MyPageViewController.swift
//  On_off_iOS
//
//  Created by 정호진 on 2/15/24.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

final class MyPageViewController: UIViewController {
    
    /// 닉네임 라벨
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "조디 님"
        label.backgroundColor = .clear
        label.textColor = .OnOffPurple
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    /// 업무분야, 경력 라벨
    private lazy var fieldOfWorkAndExperienceYearLabel: UILabel = {
        let label = UILabel()
        label.text = "업무분야 | 연차"
        label.backgroundColor = .clear
        label.textColor = UIColor(hex: "#BDBDBD")
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    /// Top UI View
    private lazy var topUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = 20
        return view
    }()
    
    /// Top UI StackView
    private lazy var topUIStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [bookMarkButton, alertSettingButton, faqButton, myInfoButton])
        view.backgroundColor = .clear
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    /// Book Mark Button
    private lazy var bookMarkButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "bookMark", title: "북마크")
        return button
    }()
    
    /// Alert Setting Button
    private lazy var alertSettingButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "alertSetting", title: "알림 설정")
        return button
    }()
    
    /// faq Button
    private lazy var faqButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "faq", title: "FAQ")
        return button
    }()
    
    /// My Info Button
    private lazy var myInfoButton: TopCustomButton = {
        let button = TopCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "myInfo", title: "내정보")
        return button
    }()
    
    /// List UI View
    private lazy var listUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// List UIStackView
    private lazy var listUIStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [noticeButton,
                                                  feedBackButton,
                                                  policyButton,
                                                  versionButton,
                                                  reportButton,
                                                  logOutButton,
                                                  getOutButton])
        view.backgroundColor = .clear
        view.spacing = 20
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    /// 공지사항 버튼
    private lazy var noticeButton: ListCustomButton = {
        let button = ListCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "list",
                         title: "공지사항",
                         titleColor: .black,
                         rightSide: "",
                         rightSideImage: "화살표")
        return button
    }()
    
    /// 피드백 공간 버튼
    private lazy var feedBackButton: ListCustomButton = {
        let button = ListCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "feedBack",
                         title: "피드백 공간",
                         titleColor: .black,
                         rightSide: "",
                         rightSideImage: "화살표")
        return button
    }()
    
    /// 약관 및 정책 버튼
    private lazy var policyButton: ListCustomButton = {
        let button = ListCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "policy",
                         title: "약관 및 정책",
                         titleColor: .black,
                         rightSide: "",
                         rightSideImage: "화살표")
        return button
    }()
    
    /// 버전 버튼
    private lazy var versionButton: ListCustomButton = {
        let button = ListCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: "version", 
                         title: "현재 버전",
                         titleColor: .black,
                         rightSide: "v 1.0.0",
                         rightSideImage: nil)
        return button
    }()
    
    /// 신고하기 버튼
    private lazy var reportButton: ListCustomButton = {
        let button = ListCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: nil,
                         title: "신고하기",
                         titleColor: .red,
                         rightSide: "",
                         rightSideImage: "화살표")
        return button
    }()
    
    /// 로그아웃 버튼
    private lazy var logOutButton: ListCustomButton = {
        let button = ListCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: nil,
                         title: "로그아웃",
                         titleColor: .gray,
                         rightSide: "",
                         rightSideImage: nil)
        return button
    }()
    
    /// 탈퇴하기 버튼
    private lazy var getOutButton: ListCustomButton = {
        let button = ListCustomButton()
        button.backgroundColor = .clear
        button.inputData(icon: nil,
                         title: "탈퇴하기",
                         titleColor: .red,
                         rightSide: "",
                         rightSideImage: nil)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel = MyPageViewModel()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        bind()
    }
    
    /// Add SubViews
    private func addSubViews() {
        view.addSubview(nickNameLabel)
        view.addSubview(fieldOfWorkAndExperienceYearLabel)
        view.addSubview(topUIView)
        view.addSubview(topUIStackView)
        view.addSubview(listUIView)
        listUIView.addSubview(listUIStackView)
        
        constraints()
    }
    
    /// Constraints
    private func constraints() {
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.centerX.equalToSuperview()
        }
        
        fieldOfWorkAndExperienceYearLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        topUIView.snp.makeConstraints { make in
            make.top.equalTo(topUIStackView.snp.top).offset(-10)
            make.bottom.equalTo(topUIStackView.snp.bottom).offset(15)
            make.leading.equalTo(topUIStackView.snp.leading).offset(-10)
            make.trailing.equalTo(topUIStackView.snp.trailing).offset(10)
        }
        
        topUIStackView.snp.makeConstraints { make in
            make.top.equalTo(fieldOfWorkAndExperienceYearLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        listUIView.snp.makeConstraints { make in
            make.top.equalTo(topUIView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        listUIStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    /// Bind
    private func bind() {
        let input = MyPageViewModel.Input(bookMarkButtonEvents: bookMarkButton.rx.tap,
                                          alertSettingButtonEvents: alertSettingButton.rx.tap,
                                          myInfoButtonEvents: myInfoButton.rx.tap,
                                          versionButton: versionButton.rx.tap,
                                          reportButton: reportButton.rx.tap,
                                          logOutButton: logOutButton.rx.tap,
                                          getOutButton: getOutButton.rx.tap)
        
        let output = viewModel.createOutput(input: input)
        bindNickNameRelay(output: output)
        bindSubTitleRelay(output: output)
        bindBookmarkButton()
        bindAlertSettingButton()
        bindPolicyButton()
        bindFeedBackButton()
        bindNoticeButton()
        bindFAQButton()
        bindMyInfoSettingButton()
    }
    
    /// Bind Nick Name Relay
    private func bindNickNameRelay(output: MyPageViewModel.Output) {
        output.nickNameRelay
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    /// Bind Sub Title Relay
    private func bindSubTitleRelay(output: MyPageViewModel.Output) {
        output.subTitleRelay
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                fieldOfWorkAndExperienceYearLabel.textColor = .black
            })
            .bind(to: fieldOfWorkAndExperienceYearLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    /// Bind Bookmark Button
    private func bindBookmarkButton() {
        bookMarkButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let bookmarkViewController = BookmarkViewController(viewModel: BookmarkViewModel())
                bookmarkViewController.navigationItem.title = "북마크"
                navigationController?.pushViewController(bookmarkViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }

    /// Bind Alert Setting Button
    private func bindAlertSettingButton() {
        alertSettingButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let setAlertViewController = SetAlertViewController()
                setAlertViewController.navigationItem.title = "알림설정"
                navigationController?.pushViewController(setAlertViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindMyInfoSettingButton() {
        myInfoButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let myInfoSettingViewController = MyInfoSettingViewController(viewModel: ProfileSettingViewModel(loginService: LoginService()))
                myInfoSettingViewController.navigationItem.title = "마이페이지"
                navigationController?.pushViewController(myInfoSettingViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Policy Button
    private func bindPolicyButton() {
        policyButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let url = "https://jungseo0.notion.site/cdc22df3df514d11a8f9e30f99de2f02"
                let webViewController = WebViewController()
                webViewController.url = url
                navigationController?.pushViewController(webViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Feed Back Button
    private func bindFeedBackButton() {
        feedBackButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let url = "https://jungseo0.notion.site/b9441203ee8b4294ab8f71d6b4846916"
                let webViewController = WebViewController()
                webViewController.url = url
                navigationController?.pushViewController(webViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding Notice Button
    private func bindNoticeButton() {
        noticeButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let url = "https://jungseo0.notion.site/839bef18339a430099227c816516788d"
                let webViewController = WebViewController()
                webViewController.url = url
                navigationController?.pushViewController(webViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// Binding FAQ Button
    private func bindFAQButton() {
        faqButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let url = "https://jungseo0.notion.site/FAQ-a4a98155fa3845bc88bfda0e40905e16"
                let webViewController = WebViewController()
                webViewController.url = url
                navigationController?.pushViewController(webViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
}
