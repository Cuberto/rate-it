//
//  ProgressableAnimationView.swift
//  eyeTest
//
//  Created by Anton Skopin on 26.08.2019.
//  Copyright © 2019 Anton Skopin. All rights reserved.
//

import UIKit

enum Rate: CaseIterable {
    case bad
    case normal
    case good

    static var allCases: [Rate] {
        return [.bad, .normal, .good]
    }

    var keyTime: Float {
        switch self {
            case .bad:
                return 0
            case .normal:
                return 0.5
            case .good:
                return 1
        }
    }
}

protocol RateAnimation {
    var keypath: String { get }
    func value(for state: Rate, viewSize: CGSize) -> Any
}

class AnimationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    func configure() {

    }
}

class ProgressableAnimationView: AnimationView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func configure() {
        super.configure()
        updateAnimation(withProgress: 0)
    }

    var animationLayer: CALayer {
        return layer
    }

    var animationKey: String {
        return "animation"
    }

    var animations: [RateAnimation] {
        return []
    }

    func updateAnimation(withProgress progress: Double) {
       let coreAnimations: [CAAnimation] = animations.map { animation in
            let coreAnimation = CAKeyframeAnimation(keyPath: animation.keypath)
            coreAnimation.values = Rate.allCases.map { animation.value(for: $0, viewSize: animationLayer.bounds.size) }
            coreAnimation.keyTimes = Rate.allCases.map { NSNumber(value: $0.keyTime) }
            return coreAnimation
        }
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = coreAnimations
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards
        animationGroup.duration = 1.0001
        animationGroup.speed = 0
        animationGroup.timeOffset = min(1, max(0, progress))

        animationLayer.add(animationGroup, forKey: animationKey)
    }

    var progress: Double = 0 {
        didSet {
            updateAnimation(withProgress: progress)
        }
    }

    func animate(to state: Rate, duration: TimeInterval = 0.2) {
       CATransaction.begin()
       CATransaction.setDisableActions(true)
       let coreAnimations: [CAAnimation] = animations.compactMap { animation in
            guard let currentValue = animationLayer.presentation()?.value(forKeyPath: animation.keypath) else {
                return nil
            }
            let targetValues = animation.value(for: state, viewSize: animationLayer.bounds.size)
            let coreAnimation = CABasicAnimation(keyPath: animation.keypath)
            coreAnimation.fromValue = currentValue
            coreAnimation.toValue = targetValues
            return coreAnimation
        }
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = coreAnimations
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards
        animationGroup.duration = duration
        animationLayer.add(animationGroup, forKey: animationKey)
        CATransaction.commit()
    }
    
}
