//
//  GeometryHelper.swift
//  eyeTest
//
//  Created by Anton Skopin on 23.08.2019.
//  Copyright © 2019 Anton Skopin. All rights reserved.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat = 0, dy: CGFloat = 0) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }

    static func distance(from lhs: CGPoint, to rhs: CGPoint) -> CGFloat {
        let xDistance = lhs.x - rhs.x
        let yDistance = lhs.y - rhs.y
        return (xDistance * xDistance + yDistance * yDistance).squareRoot()
    }

    func distance(to point: CGPoint) -> CGFloat {
        return CGPoint.distance(from: self, to: point)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
