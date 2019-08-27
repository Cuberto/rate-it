//
//  TitleView.swift
//  eyeTest
//
//  Created by Anton Skopin on 26.08.2019.
//  Copyright © 2019 Anton Skopin. All rights reserved.
//

import UIKit

extension Rate {
    var title: String {
        switch self {
        case .bad:
            return "Hideous"
        case .normal:
            return "Ok"
        case .good:
            return "Good"
        }
    }
}

class TitleView: AnimationView {

    class TitleLabel: UILabel {
        var state: Rate!
        var csHorPosition: NSLayoutConstraint!
        var csVertPosition: NSLayoutConstraint!
    }

    var labels: [Rate: TitleLabel] = [:]
    override func configure() {
        super.configure()
        backgroundColor = .clear
        Rate.allCases.forEach {
            let label = TitleLabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 27, weight: .regular)
            label.textColor = .black
            label.text = $0.title
            label.state = $0
            addSubview(label)
            label.csHorPosition = label.centerXAnchor.constraint(equalTo: centerXAnchor)
            label.csVertPosition = label.centerYAnchor.constraint(equalTo: centerYAnchor)
            labels[$0] = label
        }
        let constraints: [NSLayoutConstraint] = labels.values.flatMap {
            return [$0.csHorPosition, $0.csVertPosition]
        }.compactMap { $0 }
        NSLayoutConstraint.activate(constraints)
        updateState(to: .bad)
    }

    func updateState(to state: Rate) {
        self.state = state
        let offset: CGFloat = 70
        for label in labels.values {
            label.alpha = label.state == state ? 1 : 0
            if label.state == state {
                label.csHorPosition?.constant = 0
            } else if label.state.keyTime < state.keyTime {
                label.csHorPosition?.constant = -offset
            } else {
                label.csHorPosition?.constant = offset
            }
        }
    }
    
    var state: Rate = .bad
    func animate(to state: Rate, duration: TimeInterval = 0.2) {
        guard state != self.state else {
            return
        }
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState], animations: {
            self.updateState(to: state)
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
