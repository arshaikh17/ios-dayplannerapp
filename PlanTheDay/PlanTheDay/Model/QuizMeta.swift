//
//  Quiz.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 03/05/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation


class QuizMeta : Decodable
{
    var status = String()
    var quiz_id = Int32()
    var totalQuestions = Int32()
    
    init(status: String, quiz_id: Int32, totalQuestions: Int32)
    {
        self.status = status
        self.quiz_id = quiz_id
        self.totalQuestions = totalQuestions
    }
}
