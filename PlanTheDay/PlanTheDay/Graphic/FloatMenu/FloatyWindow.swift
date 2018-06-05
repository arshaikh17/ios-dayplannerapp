//
//  FloatyWindow.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 31/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit

/**
 KCFloatingActionButton dependent on UIWindow.
 */
class FloatyWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.windowLevel = UIWindowLevelNormal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let floatyViewController = rootViewController as? FloatyViewController
        if let floaty = floatyViewController?.floaty {
            if floaty.closed == false {
                return true
            }
            
            if floaty.frame.contains(point) == true {
                return true
            }
            
            for item in floaty.items {
                let itemFrame = self.convert(item.frame, from: floaty)
                if itemFrame.contains(point) == true {
                    return true
                }
            }
        }
        
        return false
    }
}
