//
//  CustomPageControl.swift
//  On_off_iOS
//
//  Created by 박다미 on 2024/01/01.
//

import UIKit

/// customPageControl
final class CustomPageControl: UIView {
    /// 페이지 총 개수
    var numberOfPages: Int = 0 {
        didSet { setupDots() } /// 페이지 수가 설정될 때 점들 설정
    }
    /// 현재 선택된 페이지
    var currentPage: Int = 0 {
        didSet { updateDotStyles() } /// 현재 페이지가 변경될 때 점의 스타일을 업데이트
    }
    private var dotViews: [UIView] = []
    
    private let activeDotSize: CGSize = CGSize(width: 20, height: 10)
    private let inactiveDotSize: CGSize = CGSize(width: 10, height: 10)
    
    private func setupDots() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews = []
        
        for _ in 0..<numberOfPages {
            let dot = UIView()
            dot.backgroundColor = .lightGray
            dot.layer.cornerRadius = inactiveDotSize.height / 2
            addSubview(dot)
            dotViews.append(dot)
        }
        
        setNeedsLayout()
    }
    /// 점들의 스타일을 업데이트
    private func updateDotStyles() {
        for (index, dot) in dotViews.enumerated() {
            if index == currentPage {
                dot.backgroundColor = .gray
                dot.frame.size = activeDotSize
                dot.layer.cornerRadius = activeDotSize.height / 2
                continue
            }
                dot.backgroundColor = .lightGray
                dot.frame.size = inactiveDotSize
                dot.layer.cornerRadius = inactiveDotSize.height / 2
        }
        setNeedsLayout()
    }
    
    /// 뷰의 서브뷰 레이아웃을 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        let totalWidth: CGFloat = dotViews.reduce(0) { $0 + $1.frame.width } + CGFloat(numberOfPages - 1) * 10
        var currentX: CGFloat = (bounds.width - totalWidth) / 2
        for dot in dotViews {
            dot.frame = CGRect(x: currentX, y: (bounds.height - dot.frame.height) / 2, width: dot.frame.width, height: dot.frame.height)
            currentX += dot.frame.width + 10
        }
    }
    
    /// 스크롤에 따라 페이지 인디케이터 업데이트
    func updateForScroll(offsetX: CGFloat, scrollViewWidth: CGFloat) {
        let page = offsetX / scrollViewWidth
        
        /// navigaion에 감싸졌을때 page에러
        if page.isInfinite || page.isNaN {
            return
        }
        let currentPage = Int(page)
        let nextPage = currentPage + 1
        
        let progress = page - CGFloat(currentPage)
        
        for (index, dot) in dotViews.enumerated() {
            dot.frame.size = inactiveDotSize
            dot.frame.size = inactiveDotSize
            
            if index == currentPage {
                let activeWidth = inactiveDotSize.width + (activeDotSize.width - inactiveDotSize.width) * (1 - progress)
                dot.frame.size = CGSize(width: activeWidth, height: dot.frame.height)
            }
            if index == nextPage {
                let activeWidth = inactiveDotSize.width + (activeDotSize.width - inactiveDotSize.width) * progress
                dot.frame.size = CGSize(width: activeWidth, height: dot.frame.height)
            }
            dot.layer.cornerRadius = dot.frame.height / 2
        }
        setNeedsLayout()
    }

}
