//
//  ViewController.swift
//  Rate-It
//
//  Created by Anton Skopin on 27.08.2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var leftEye: EyeView! {
        didSet {
            leftEye.mode = .left
        }
    }
    @IBOutlet private weak var rightEye: EyeView! {
        didSet {
            rightEye.mode = .right
        }
    }
    @IBOutlet private weak var bgView: BackgroundView!
    @IBOutlet private weak var mouthView: MouthView!
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
            slider.addTarget(self, action: #selector(endTracking), for: .touchUpOutside)
            slider.addTarget(self, action: #selector(endTracking), for: .touchUpInside)
            slider.setThumbImage(#imageLiteral(resourceName: "track"), for: .normal)
            slider.setMinimumTrackImage(#imageLiteral(resourceName: "sliderTrack"), for: .normal)
            slider.setMaximumTrackImage(#imageLiteral(resourceName: "sliderTrack"), for: .normal)
        }
    }
    @IBOutlet private weak var textValueView: TitleView!
    @IBOutlet private weak var faceContainer: UIView!
    private var shakeTimer: Timer?
    private let startState: AnimationState = .normal

    override func viewDidLoad() {
        super.viewDidLoad()
        textValueView.updateState(to: startState)
        slider.setValue(startState.keyTime, animated: false)
        sliderMoved(sender: slider)
    }

    private func startShaking() {
        guard shakeTimer == nil else {
            return
        }
        shakeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] (timer) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.faceContainer.shake(count: 7, amplitude: 3.5)
        }
    }

    private func stopShaking() {
        shakeTimer?.invalidate()
        shakeTimer = nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopShaking()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShake && !isShaking {
            startShaking()
        }
    }

    private var normalizedProgress: Float {
        return (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
    }

    private var targetState: AnimationState {
        return AnimationState.allCases.reduce((.bad, Float.greatestFiniteMagnitude)) { (acc, state) -> (AnimationState, Float) in
            let diff = abs(normalizedProgress - state.keyTime)
            if  diff < abs(acc.1) {
                return (state, diff)
            }
            return acc
        }.0
    }

    private var shouldShake: Bool {
        return targetState == .bad
    }

    private var isShaking: Bool {
        return shakeTimer != nil
    }

    @objc private func sliderMoved(sender: UISlider) {
        let trackPoint = CGPoint(x: slider.frame.width * CGFloat(normalizedProgress), y: slider.frame.midY)
        [leftEye, rightEye, bgView, mouthView].forEach {
            $0?.progress = Double(normalizedProgress)
        }
        [leftEye, rightEye].forEach {
            $0?.track(to: $0?.convert(trackPoint, from: view), animated: ($0?.trackPoint == nil))
        }
        textValueView.animate(to: targetState)
        if shouldShake && !isShaking {
            startShaking()
        }
        if !shouldShake && isShaking {
            stopShaking()
        }
    }

    @objc private func endTracking() {
        [leftEye, rightEye].forEach {
            $0.track(to: nil, animated: true)
        }
        [leftEye, rightEye, bgView, mouthView].forEach {
            $0?.animate(to: targetState)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.slider.setValue(self.targetState.keyTime, animated: true)
        })
    }

}
