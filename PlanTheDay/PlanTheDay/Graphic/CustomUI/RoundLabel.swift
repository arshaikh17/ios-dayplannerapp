//
//  RoundLabel.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 01/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit

class RoundLabel
{
    func drawRoundLabel(label: UILabel, text: String)
    {
        let size:CGFloat = 80.0
        
        label.frame = CGRect(x : 0.0,y : 0.0,width : size, height :  size)
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.layer.cornerRadius = size / 2
        label.layer.borderWidth = 3.0
        label.layer.masksToBounds = true
        label.layer.backgroundColor = UIColor.orange.cgColor
        label.backgroundColor = UIColor.orange
        label.layer.borderColor = UIColor.orange.cgColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
    }
}
