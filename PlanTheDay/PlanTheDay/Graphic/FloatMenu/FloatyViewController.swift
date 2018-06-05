//
//  FloatyViewController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 31/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//


import UIKit

/**
 KCFloatingActionButton dependent on UIWindow.
 */
open class FloatyViewController: UIViewController {
    open let floaty = Floaty()
    var statusBarStyle: UIStatusBarStyle = .default
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floaty)
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return statusBarStyle
        }
    }
}
