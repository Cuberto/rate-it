//
//  BackgroundView.swift
//  eyeTest
//
//  Created by Anton Skopin on 26.08.2019.
//  Copyright © 2019 Anton Skopin. All rights reserved.
//

import UIKit

class BackgroundView: ProgressableAnimationView {

    override var animations: [Animation] {
        return [Animation(keypath: "backgroundColor",
                          values: [.bad: #colorLiteral(red: 0.9921568627, green: 0.7450980392, blue: 0.9215686275, alpha: 1).cgColor,
                                   .normal: #colorLiteral(red: 0.9921568627, green: 0.9333333333, blue: 0.7450980392, alpha: 1).cgColor,
                                   .good: #colorLiteral(red: 0.7450980392, green: 0.9921568627, blue: 0.8980392157, alpha: 1).cgColor])]
    }

}
