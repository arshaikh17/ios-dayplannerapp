//
//  AlertController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 29/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import UIKit

class AlertController: UIViewController
{
    func SimpleAlert(title: String, message: String, buttonTitle: String, fromController controller: UIViewController)
    {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default,handler: nil))
        
        controller.present(alertController, animated: true, completion: nil)
    }
}
