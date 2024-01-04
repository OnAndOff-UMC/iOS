//
//  HomeViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/1/24.
//

import Foundation
import UIKit
import SnapKit


class HomeViewController: UIViewController {
    
    // 날짜 데이터 예시
    let dateData = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.tag = 1
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    //조디~환영합니다 + switch버튼 들어갈 공간 + 밑에 줄 들어갈 공간
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //날짜 collectionView 가로 스크롤 -> 혹시 몰라서
    lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        //        collectionView.delegate = self
        //        collectionView.dataSource = self
        return collectionView
    }()
    
    //테이블뷰가 들어갈 뷰 -> 오늘의 다짐 등 반복되는 뷰 넣기
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        //        tableView.delegate = self
        //        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        topView.addSubview(dateCollectionView)
        bottomView.addSubview(tableView)
        
        //        bottomView.addSubview()
        
        configureConstraints()
        // 추가된 부분: 날짜 collectionView의 데이터 소스와 델리게이트 설정
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCell")
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        //        setTableView()
        //        setCollectionView()
        //        scrollView.delegate = self
        
        //
        //        let scrollView = UIScrollView()
        //        view.addSubview(scrollView)
        //        scrollView.snp.makeConstraints { make in
        //            make.edges.equalToSuperview()
        //        }
        //
        //        // 유저의 닉네임을 받아오는 부분 (예: "조디님")
        //        let userName = "조디님"
        //
        //        let label = UILabel()
        //        label.textColor = .black
        //        label.font = UIFont.boldSystemFont(ofSize: 20)
        //        label.numberOfLines = 0
        //        label.lineBreakMode = .byWordWrapping
        //
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineHeightMultiple = 0.86
        //
        
        //        // 유저의 닉네임을 customPurple 색상으로 설정하고, 나머지는 검은색으로
        //        let attributedString = NSMutableAttributedString(string: "\(userName),\n오늘 하루도 파이팅!", attributes: [NSAttributedString.Key.kern: -0.52, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        //
        //        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.customPurple, range: NSRange(location: 0, length: userName.count))
        //
        //        label.attributedText = attributedString
        //
        //        scrollView.addSubview(label)
        //
        //        label.snp.makeConstraints { make in
        //            make.width.equalTo(159)
        //            make.height.greaterThanOrEqualTo(47)
        //            make.leading.equalToSuperview().offset(23)
        //            make.top.equalToSuperview().offset(86)
        //            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        //        }
        //
        //        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    //MARK: - configureConstraints()
    private func configureConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.bottom)
        }
        
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(view.snp.width).multipliedBy(0.3)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tableView.snp.bottom)
        }
        
        dateCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(500)//임의의 수 ->적용 안됨
        }
    }
    
    
    
    //    private func calculateTableViewHeight() -> CGFloat {
    //
    //        let numberOfCells =  homeGoodsDataArray.count //-> 오늘의 할일 셀 때
    //        let cellHeight: CGFloat = view.frame.width*0.3
    //        let totalHeight = CGFloat(numberOfCells-1) * cellHeight + view.frame.width*0.8
    //        return totalHeight
    //    }
    //
    //    // 테이블뷰 높이를 계산하고 업데이트하는 메서드
    //    private func updateTableViewHeight() {
    //        let newHeight = calculateTableViewHeight()
    //        tableView.snp.updateConstraints { make in
    //            make.height.equalTo(newHeight)
    //        }
    //        scrollView.layoutIfNeeded()
    //        tableView.reloadData() // 테이블뷰를 다시 로드
    //    }
    
    //    private func setCollectionView() {
    //        datecollectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.reuseIdentifier)
    //        categoryCollectionView.backgroundColor = .clear
    //        categoryCollectionView.showsHorizontalScrollIndicator = false
    //    }
    //
    //    //테이블뷰 세팅
    //    func setTableView(){
    //        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    //        tableView.register(HomeAdTableViewCell.self, forCellReuseIdentifier: HomeAdTableViewCell.reuseIdentifier)
    //
    //    }
    //
    
    
    
    //}
    
    
    
    //extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    ////        return homeCagetoryDataArray.count
    ////    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    ////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCategoryCollectionViewCell
    ////        cell.imageView.image = homeCagetoryDataArray[indexPath.row].image
    ////        cell.label.text = homeCagetoryDataArray[indexPath.row].text
    ////        return cell
    ////    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    ////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    ////
    ////
    ////        if (homeCagetoryDataArray[indexPath.row].text == "" ){
    ////            let cellHeight: CGFloat = collectionView.frame.height * 0.85
    ////
    ////            return CGSize(width: cellHeight, height: cellHeight)
    ////        }
    ////        else{
    ////            let cellPadding: CGFloat = 15
    //////            let text = homeCagetoryDataArray[indexPath.row].text
    ////
    ////            // 라벨 폰트를 설정
    ////            let font = UIFont.systemFont(ofSize: 12, weight: .regular)
    ////            // 라벨의 예상 크기를 계산
    ////            let labelSize = (text as NSString).size(withAttributes: [
    ////                NSAttributedString.Key.font: font
    ////            ])
    ////            let cellWidth = labelSize.width*2 + 2 * cellPadding
    ////            let cellHeight: CGFloat = collectionView.frame.height * 0.85
    ////
    ////            return CGSize(width: cellWidth, height: cellHeight)
    ////        }
    ////
    ////    }
    //}
    //
    ////extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    ////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    ////
    //////        return homeGoodsDataArray.count
    ////    }
    ////
    ////
    //////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //////        if indexPath.row == 6{
    //////            let cell = tableView.dequeueReusableCell(withIdentifier: HomeAdTableViewCell.reuseIdentifier, for: indexPath) as! HomeAdTableViewCell
    //////            return cell
    //////        }else {
    //////            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
    //////            cell.goodsImage.image = homeGoodsDataArray[indexPath.row].goodsImage
    //////            cell.goodsTitle.text = homeGoodsDataArray[indexPath.row].goodsTitle
    //////            cell.locationLabel.text = homeGoodsDataArray[indexPath.row].locationLabel
    //////            cell.goodsPrice.text = homeGoodsDataArray[indexPath.row].goodsPrice
    //////            cell.ratingCustomView.talkImageView.image = homeGoodsDataArray[indexPath.row].rating.talkImage
    //////            cell.ratingCustomView.talkCount.text = homeGoodsDataArray[indexPath.row].rating.talkNum
    //////            cell.ratingCustomView.heartImageView.image = homeGoodsDataArray[indexPath.row].rating.heartImage
    //////            cell.ratingCustomView.heartCount.text = homeGoodsDataArray[indexPath.row].rating.heartNum
    //////            return cell
    //////
    //////        }
    //////    }
    ////
    ////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    ////        if indexPath.row == 6{
    ////            return view.frame.width*0.8
    ////
    ////        }else{
    ////            return view.frame.width*0.37
    ////        }
    ////    }
    ////
    ////
    ////}
    ////
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCollectionViewCell
        cell.configureCell(date: dateData[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀의 크기 설정
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}
