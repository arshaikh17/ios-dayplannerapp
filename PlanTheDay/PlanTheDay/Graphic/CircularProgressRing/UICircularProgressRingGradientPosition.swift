//
//  UICircularProgressRingGradientPosition.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 30/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import UIKit
@objc public enum UICircularProgressRingGradientPosition: Int {
    /// Gradient positioned at the top
    case top = 1
    /// Gradient positioned at the bottom
    case bottom = 2
    /// Gradient positioned to the left
    case left = 3
    /// Gradient positioned to the right
    case right = 4
    /// Gradient positioned in the top left corner
    case topLeft = 5
    /// Gradient positioned in the top right corner
    case topRight = 6
    /// Gradient positioned in the bottom left corner
    case bottomLeft = 7
    /// Gradient positioned in the bottom right corner
    case bottomRight = 8
    
    /**
     
     Returns a `CGPoint` in the coordinates space of the passed in `CGRect`
     for the specified position of the gradient.
     
     */
    func pointForPosition(in rect: CGRect) -> CGPoint {
        switch self {
        case .top:
            return CGPoint(x: rect.midX, y: rect.minY)
        case .bottom:
            return CGPoint(x: rect.midX, y: rect.maxY)
        case .left:
            return CGPoint(x: rect.minX, y: rect.midY)
        case .right:
            return CGPoint(x: rect.maxX, y: rect.midY)
        case .topLeft:
            return CGPoint(x: rect.minX, y: rect.minY)
        case .topRight:
            return CGPoint(x: rect.maxX, y: rect.minY)
        case .bottomLeft:
            return CGPoint(x: rect.minX, y: rect.maxY)
        case .bottomRight:
            return CGPoint(x: rect.maxX, y: rect.maxY)
        }
    }
}
