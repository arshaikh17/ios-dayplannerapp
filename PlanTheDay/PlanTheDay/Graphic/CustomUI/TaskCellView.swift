//
//  TaskCellView.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 06/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import UIKit

class TaskCellView: UITableViewCell
{
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var txtTaskContent: UILabel!
    @IBOutlet weak var lblTaskTime: UILabel!
    @IBOutlet weak var sldrTaskProgress: UISlider!
    
    var onProgressSliderChanged : (() -> Void)? = nil
    
    @IBAction func progressSliderChange(sender: UISlider) {
        if let onProgressSliderChanged = self.onProgressSliderChanged {
            onProgressSliderChanged()
        }
    }
}
