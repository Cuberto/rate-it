//
//  EyeView.swift
//  eyeTest
//
//  Created by Anton Skopin on 22.08.2019.
//  Copyright © 2019 Anton Skopin. All rights reserved.
//

import UIKit

class EyeView: ProgressableAnimationView {

    enum Mode {
        case left
        case right
    }

    private let eyeLayerWrapper = CALayer()

    private let eyeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 4.0
        return layer
    }()

    static let appleSize: CGFloat = 8.0
    private let appleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(origin: .zero, size: CGSize(width: appleSize, height: appleSize))
        layer.fillColor = UIColor.black.cgColor
        layer.path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: appleSize, height: appleSize))).cgPath
        return layer
    }()

    override func configure() {
        layer.addSublayer(eyeLayerWrapper)
        eyeLayerWrapper.addSublayer(eyeLayer)
        layer.addSublayer(appleLayer)
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
        eyeLayerWrapper.frame = bounds
        eyeLayer.frame = eyeLayerWrapper.bounds
        appleLayer.frame = CGRect(x: bounds.midX - appleLayer.frame.width/2.0,
                                  y: bounds.midY - appleLayer.frame.height/2.0,
                                  width: appleLayer.frame.width,
                                  height: appleLayer.frame.height)
        updateAnimation(withProgress: progress)
    }

    private var applesXOffsetScale: CGFloat {
        return 7 * bounds.width/158
    }

    private var applesYOffset: CGFloat {
        return 8
    }

    var trackPoint: CGPoint?
    func track(to point: CGPoint?, animated: Bool = false) {
            if !animated {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
            }
            defer {
                if !animated {
                    CATransaction.commit()
                }
            }
            trackPoint = point
            guard let point = point else {
                appleLayer.transform = CATransform3DIdentity
                return
            }
            let yOffset: CGFloat = 8
            var xOffset: CGFloat = (point.x - bounds.midX) * yOffset/(point.y - bounds.midY) * applesXOffsetScale
            guard let eyePath = eyeLayer.presentation()?.path else { return }

            var targetPoint: CGPoint
            var testPoint: CGPoint
            let offsetSign: CGFloat = xOffset > 0 ? 1 : -1
            repeat {
                targetPoint = bounds.center.offsetBy(dx: xOffset, dy: yOffset)
                if mode == .left {
                    testPoint = bounds.center.offsetBy(dx: -xOffset, dy: yOffset).offsetBy(dx: -offsetSign * EyeView.appleSize)
                } else {
                    testPoint = targetPoint.offsetBy(dx: offsetSign * EyeView.appleSize)
                }
                xOffset -= offsetSign * 1
            } while !eyePath.contains(testPoint)
            appleLayer.transform = CATransform3DMakeTranslation(xOffset, yOffset, 1)
    }

    private let pathAnimation = EyeViewPathAnimation()
    private let transformAnimation = EyeViewTransformAnimation()
    override var animations: [RateAnimation] {
        return [pathAnimation, transformAnimation]
    }
    override var animationLayer: CALayer {
        return eyeLayer
    }

    var mode: Mode = .right {
        didSet {
            eyeLayerWrapper.transform = (mode == .left) ? CATransform3DMakeScale(-1, 1, 1) : CATransform3DIdentity
        }
    }
}

// MARK: - Animation

private struct EyeViewTransformAnimation: RateAnimation  {

    var keypath: String {
        return "transform"
    }

    func value(for state: Rate, viewSize: CGSize) -> Any {
        switch state {
            case .bad:
                return CATransform3DIdentity
            case .normal:
                return CATransform3DMakeRotation(6 * CGFloat.pi/180, 0, 0, 1)
            case .good:
                return CATransform3DIdentity
        }
    }

}

private struct EyeViewPathAnimation: RateAnimation {

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
        let orig = CGSize(width: 90, height: 70)
        let coeff = size.width/orig.width

        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 16 * coeff, y: 25 * coeff))
        shape.addCurve(to: CGPoint(x: 48.51 * coeff, y: 28.34 * coeff), controlPoint1: CGPoint(x: 32.2 * coeff, y: 27.09 * coeff), controlPoint2: CGPoint(x: 43.04 * coeff, y: 28.2 * coeff))
        shape.addCurve(to: CGPoint(x: 73 * coeff, y: 26.25 * coeff), controlPoint1: CGPoint(x: 53.99 * coeff, y: 28.48 * coeff), controlPoint2: CGPoint(x: 62.15 * coeff, y: 27.78 * coeff))
        shape.addCurve(to: CGPoint(x: 54.74 * coeff, y: 73.88 * coeff), controlPoint1: CGPoint(x: 66.28 * coeff, y: 53.93 * coeff), controlPoint2: CGPoint(x: 60.19 * coeff, y: 69.81 * coeff))
        shape.addCurve(to: CGPoint(x: 27.48 * coeff, y: 54.51 * coeff), controlPoint1: CGPoint(x: 50.63 * coeff, y: 76.96 * coeff), controlPoint2: CGPoint(x: 40.4 * coeff, y: 74.65 * coeff))
        shape.addCurve(to: CGPoint(x: 16 * coeff, y: 25 * coeff), controlPoint1: CGPoint(x: 24.68 * coeff, y: 50.15 * coeff), controlPoint2: CGPoint(x: 20.85 * coeff, y: 40.32 * coeff))
        shape.close()
        return shape
    }

    private func normalPath(ofSize size: CGSize) -> UIBezierPath {
        let orig = CGSize(width: 90, height: 70)
        let coeff = size.width/orig.width
        let shape = UIBezierPath()

        shape.move(to: CGPoint(x: 20.9 * coeff, y: 30.94 * coeff))
        shape.addCurve(to: CGPoint(x: 42.96 * coeff, y: 32.56 * coeff), controlPoint1: CGPoint(x: 31.26 * coeff, y: 31.66 * coeff), controlPoint2: CGPoint(x: 38.61 * coeff, y: 32.2 * coeff))
        shape.addCurve(to: CGPoint(x: 81.11 * coeff, y: 38.32 * coeff), controlPoint1: CGPoint(x: 66.94 * coeff, y: 34.53 * coeff), controlPoint2: CGPoint(x: 79.65 * coeff, y: 36.45 * coeff))
        shape.addCurve(to: CGPoint(x: 65.83 * coeff, y: 59.52 * coeff), controlPoint1: CGPoint(x: 83.9 * coeff, y: 41.9 * coeff), controlPoint2: CGPoint(x: 73.77 * coeff, y: 56.6 * coeff))
        shape.addCurve(to: CGPoint(x: 32.42 * coeff, y: 49.7 * coeff), controlPoint1: CGPoint(x: 61.95 * coeff, y: 60.95 * coeff), controlPoint2: CGPoint(x: 45.72 * coeff, y: 58.91 * coeff))
        shape.addCurve(to: CGPoint(x: 20.9 * coeff, y: 30.94 * coeff), controlPoint1: CGPoint(x: 23.56 * coeff, y: 43.56 * coeff), controlPoint2: CGPoint(x: 19.71 * coeff, y: 37.3 * coeff))
        shape.close()
        return shape
    }

    private func goodPath(ofSize size: CGSize) -> UIBezierPath {
        let orig = CGSize(width: 90, height: 70)
        let coeff = size.width/orig.width

         let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 21 * coeff, y: 45 * coeff))
        shape.addCurve(to: CGPoint(x: 29.41 * coeff, y: 24.47 * coeff), controlPoint1: CGPoint(x: 21 * coeff, y: 36.78 * coeff), controlPoint2: CGPoint(x: 24.26 * coeff, y: 29.42 * coeff))
        shape.addCurve(to: CGPoint(x: 45 * coeff, y: 18 * coeff), controlPoint1: CGPoint(x: 33.61 * coeff, y: 20.43 * coeff), controlPoint2: CGPoint(x: 38.05 * coeff, y: 18 * coeff))
        shape.addCurve(to: CGPoint(x: 69 * coeff, y: 45 * coeff), controlPoint1: CGPoint(x: 58.25 * coeff, y: 18 * coeff), controlPoint2: CGPoint(x: 69 * coeff, y: 30.09 * coeff))
        shape.addCurve(to: CGPoint(x: 45 * coeff, y: 72 * coeff), controlPoint1: CGPoint(x: 69 * coeff, y: 59.91 * coeff), controlPoint2: CGPoint(x: 58.25 * coeff, y: 72 * coeff))
        shape.addCurve(to: CGPoint(x: 21 * coeff, y: 45 * coeff), controlPoint1: CGPoint(x: 31.75 * coeff, y: 72 * coeff), controlPoint2: CGPoint(x: 21 * coeff, y: 59.91 * coeff))

        shape.close()
        return shape
    }

}
