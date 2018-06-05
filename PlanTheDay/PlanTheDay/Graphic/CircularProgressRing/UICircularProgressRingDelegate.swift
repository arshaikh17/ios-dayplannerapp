//
//  UICircularProgressRingDelegate.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 30/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import UIKit

/**
 This is the protocol declaration for the UICircularProgressRingView delegate property
 
 ## Important ##
 When progress is done updating via UICircularProgressRingView.setValue(_:), the
 finishedUpdatingProgress(forRing: UICircularProgressRingView) will be called.
 
 The ring will be passed to the delegate in order to keep
 track of multiple ring updates if needed.
 
 ## Author
 Luis Padron
 */
@objc public protocol UICircularProgressRingDelegate: class {
    /**
     Delegate call back, called when progress ring is done animating for current value
     
     - Parameter ring: The ring which finished animating
     
     */
    @objc optional func finishedUpdatingProgress(forRing ring: UICircularProgressRingView)
    
    /**
     This method is called whenever the value is updated, this means during animation this method will be called in real time.
     This can be used to update another label or do some other work, whenever you need the exact current value of the ring
     during animation.
     ## Important:
     This is a very hot method and may be called hundreds of times per second during animations. As such make sure to only
     do very simple and non-intensive work in this method. Do any work that takes time will considerably slow down your application.
     - Paramater newValue: The value which the ring has updated to
     */
    @objc optional func didUpdateProgressValue(to newValue: CGFloat)
    
    /**
     This method is called whenever the label is about to be drawn.
     This can be used to modify the label looks e.g. NSAttributedString for text kerning
     
     */
    @objc optional func willDisplayLabel(label: UILabel)
}
