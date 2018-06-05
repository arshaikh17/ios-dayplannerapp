//
//  Quiz.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 03/05/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation


class Quiz : Decodable
{
    var status = String()
    var quiz_id = Int()
    var questions = Array<String>()
    var answers1 = Array<String>()
    var answers2 = Array<String>()
    var answers3 = Array<String>()
    var correctAnswers = Array<String>()
    
    init(status: String)
    {
        self.status = status
    }
}
