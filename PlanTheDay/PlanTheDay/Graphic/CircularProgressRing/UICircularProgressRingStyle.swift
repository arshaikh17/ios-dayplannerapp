//
//  UICircularProgressRingStyle.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 30/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
@objc public enum UICircularProgressRingStyle: Int {
    /// Inner ring is inside the circle
    case inside = 1
    /// Inner ring is placed ontop of the outer ring
    case ontop = 2
    /// Outer ring is dashed
    case dashed = 3
    /// Outer ring is dotted
    case dotted = 4
    /// Inner ring is placed ontop of the outer ring and it has a gradient
    case gradient = 5
}
