//
//  TapBar.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import Foundation
import UIKit

class TabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    private func addShape() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = createPath()
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            shapeLayer.fillColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
            shapeLayer.lineWidth = 0.5
            shapeLayer.shadowOffset = CGSize(width:0, height:0)
            shapeLayer.shadowRadius = 10
            shapeLayer.shadowColor = UIColor.gray.cgColor
            shapeLayer.shadowOpacity = 0.3

            if let oldShapeLayer = self.shapeLayer {
                self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
            } else {
                self.layer.insertSublayer(shapeLayer, at: 0)
            }
            self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
           let height: CGFloat = 86.0
           let path = UIBezierPath()
           let centerWidth = self.frame.width / 2
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
           path.addCurve(to: CGPoint(x: centerWidth, y: height - 40),
                         controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
           path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                         controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
           path.addLine(to: CGPoint(x: self.frame.width, y: 0))
           path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
           path.addLine(to: CGPoint(x: 0, y: self.frame.height))
           path.close()
           return path.cgPath
        
        //스마트렌즈 버튼의 모양에 맞는 원형 홈
//        let radius: CGFloat = 37.0
//        let path = UIBezierPath()
//        let centerWidth = self.frame.width / 2
//        
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
//        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians , endAngle: CGFloat(0).degreesToRadians, clockwise: false)
//        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
//        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
//        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
//        path.close()
//        return path.cgPath
       }

    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
            for member in subviews.reversed() {
                let subPoint = member.convert(point, from: self)
                guard let result = member.hitTest(subPoint, with: event) else { continue }
                return result
            }
            return nil
    }

    
}

extension CGFloat {
    var degreesToRadians: CGFloat {return self * .pi / 180}
    var radiansToDegrees: CGFloat {return self * 180 / .pi}
}
