//
//  MouthView.swift
//  eyeTest
//
//  Created by Anton Skopin on 26.08.2019.
//  Copyright © 2019 Anton Skopin. All rights reserved.
//

import UIKit

class MouthView: ProgressableAnimationView {

    private let mouthLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 4.0
        return layer
    }()

    override func configure() {
        layer.addSublayer(mouthLayer)
        backgroundColor = .clear
        super.configure()
    }

    private var lastLayoutBounds: CGRect?
    override func layoutSubviews() {
        super.layoutSubviews()
        if let lastLayoutBounds = lastLayoutBounds,
           lastLayoutBounds.equalTo(bounds) {
            return
        }
        self.lastLayoutBounds = bounds
        mouthLayer.frame = bounds
        updateAnimation(withProgress: progress)
    }

    private let pathAnimation = MouthViewPathAnimation()
    override var animations: [RateAnimation] {
        return [pathAnimation]
    }

    override var animationLayer: CALayer {
        return mouthLayer
    }
}

private struct MouthViewPathAnimation: RateAnimation {

    var keypath: String {
        return "path"
    }

    func value(for state: Rate, viewSize: CGSize) -> Any {
        switch state {
            case .bad:
                return angryPath(ofSize: viewSize).cgPath
            case .normal:
                return normalPath(ofSize: viewSize).cgPath
            case .good:
                return goodPath(ofSize: viewSize).cgPath
        }
    }

    private func angryPath(ofSize size: CGSize) -> UIBezierPath {
        let orig = CGSize(width: 120, height: 40)
        let coeff = size.width/orig.width

        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 13 * coeff, y: 36 * coeff))
        shape.addCurve(to: CGPoint(x: 47.31 * coeff, y: 16.57 * coeff), controlPoint1: CGPoint(x: 24.69 * coeff, y: 16.57 * coeff), controlPoint2: CGPoint(x: 36.13 * coeff, y: 10.09 * coeff))
        shape.addCurve(to: CGPoint(x: 106 * coeff, y: 24.58 * coeff), controlPoint1: CGPoint(x: 63.87 * coeff, y: 6.88 * coeff), controlPoint2: CGPoint(x: 72.99 * coeff, y: -10.46 * coeff))
        return shape
    }

    func normalPath(ofSize size: CGSize) -> UIBezierPath {
        let orig = CGSize(width: 120.0, height: 40.0)
        let coeff = size.width/orig.width
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 1.0 * coeff, y: 5.0 * coeff))
        shape.addCurve(to: CGPoint(x: 45.2072933 * coeff, y: 12.93878949 * coeff), controlPoint1: CGPoint(x: 21.3645524 * coeff, y: 8.8631006 * coeff), controlPoint2: CGPoint(x: 36.1003168 * coeff, y: 11.50936377 * coeff))
        shape.addCurve(to: CGPoint(x: 118.0 * coeff, y: 19.805606623 * coeff), controlPoint1: CGPoint(x: 74.3732915 * coeff, y: 17.51666758 * coeff), controlPoint2: CGPoint(x: 98.6375271 * coeff, y: 19.805606623 * coeff))
        return shape
    }

    func goodPath(ofSize size: CGSize) -> UIBezierPath {
        let orig = CGSize(width: 120.0, height: 40.0)
        let coeff = size.width/orig.width
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 1.0 * coeff, y: 2.0 * coeff))
        shape.addCurve(to: CGPoint(x: 37.8363943 * coeff, y: 25.6597381 * coeff), controlPoint1: CGPoint(x: 17.8783339 * coeff, y: 14.0562303 * coeff), controlPoint2: CGPoint(x: 30.157132 * coeff, y: 21.942809699999998 * coeff))
        shape.addCurve(to: CGPoint(x: 118.0 * coeff, y: 16.8056066 * coeff), controlPoint1: CGPoint(x: 70.7689993 * coeff, y: 41.59982822 * coeff), controlPoint2: CGPoint(x: 97.4902012 * coeff, y: 38.64845107 * coeff))
        return shape
    }

}
