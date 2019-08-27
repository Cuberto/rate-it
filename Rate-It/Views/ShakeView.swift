//
//  ShakeView.swift
//  Rate-It
//
//  Created by Anton Skopin on 27.08.2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

extension UIView {

    var shakeAnimationKey: String {
        return "Shake"
    }

    func shake(count: Int, amplitude: CGFloat) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        var prevOffset: CGPoint = .zero
        var transforms: [CATransform3D] = [CATransform3DIdentity]
        (0..<count).forEach { _ in
            var offset: CGPoint
            repeat {
                offset = CGPoint(x: (Bool.random() ? 1 : -1) * CGFloat.random(in: 2...amplitude),
                                 y: (Bool.random() ? 1 : -1) * CGFloat.random(in: 2...amplitude))
            } while offset.distance(to: prevOffset) < amplitude
            prevOffset = offset
            transforms.append(CATransform3DMakeTranslation(offset.x, offset.y, 0))
        }
        transforms.append(CATransform3DIdentity)
        animation.values = transforms
        animation.keyTimes = (0...count + 1).map { NSNumber(value: Float($0) * 1.0 / Float(count)) }
        layer.add(animation, forKey: shakeAnimationKey)
    }
}
