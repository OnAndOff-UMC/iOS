//
//  Ext + UIImage.swift
//  On_off_iOS
//
//  Created by 정호진 on 1/25/24.
//

import Foundation
import UIKit

extension UIImage {
    /// MARK: 이미지 크기 재배치 하는 함수
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
    /// MARK: 이미지 크기 (강제)재배치 하는 함수
    func resize(newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
    /// 이미지 90도 회전
    /// - Parameter radians: radians
    /// - Returns: rotatedImage
    func rotated(by radians: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        /// 기준점을 이미지 중앙으로 이동
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        /// 주어진 각도만큼 회전
        context.rotate(by: radians)
        /// 이미지를 새 위치에 그리기
        context.draw(cgImage, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
    
    convenience init?(bounds: CGRect, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 15
        gradientLayer.colors = colors.map({ $0.cgColor })
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5);
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5);
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}
