//
//  BackgroundView.swift
//  eyeTest
//
//  Created by Anton Skopin on 26.08.2019.
//  Copyright © 2019 Anton Skopin. All rights reserved.
//

import UIKit

class BackgroundView: ProgressableAnimationView {

    private let backgroundColorAnimation = BackgroundColorAnimation()
    override var animations: [RateAnimation] {
        return [backgroundColorAnimation]
    }
    
}

private struct BackgroundColorAnimation: RateAnimation {

    var keypath: String {
        return "backgroundColor"
    }

    func value(for state: Rate, viewSize: CGSize) -> Any {
        switch state {
            case .bad:
                return #colorLiteral(red: 0.9921568627, green: 0.7450980392, blue: 0.9215686275, alpha: 1).cgColor
            case .normal:
                return #colorLiteral(red: 0.9921568627, green: 0.9333333333, blue: 0.7450980392, alpha: 1).cgColor
            case .good:
                return #colorLiteral(red: 0.7450980392, green: 0.9921568627, blue: 0.8980392157, alpha: 1).cgColor
        }
    }

}
