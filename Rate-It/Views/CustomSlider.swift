//
//  CustomSlider.swift
//  Rate-It
//
//  Created by Anton Skopin on 27.08.2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        guard let thumbImage = currentThumbImage else {
            return super.trackRect(forBounds: bounds)
        }
        return CGRect(x: thumbImage.size.width/2.0, y: bounds.midY - 0.5, width: bounds.width - thumbImage.size.width, height: 1)
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        guard let thumbImage = currentThumbImage else {
            return super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        }
        let res = CGRect(x: rect.width * CGFloat(value/(maximumValue - minimumValue)),
                      y: rect.midY - thumbImage.size.height/2.0,
                      width: thumbImage.size.width,
                      height: thumbImage.size.height)
        return res
    }
}
