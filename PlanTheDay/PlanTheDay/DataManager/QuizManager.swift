//
//  QuizManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 17/05/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import CoreData

class QuizManager
{
    let coreData = CoreDataManager()
    let defaults = UserDefaults.standard
    
    func SaveQuiz(dayID: Int32, totalQuestions: Int, quizID: Int32, score: Int32, isPassed: Int32)
    {
        let context = coreData.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Quizzes", in: context)
        let newQuiz: Quizzes = NSManagedObject(entity: entity!, insertInto: context) as! Quizzes
        
        let date = Date()
        let formatter = DateFormatter()
        
        newQuiz.day_id = dayID
        
        formatter.dateFormat = "hh:mm a"
        newQuiz.quiz_add_time = formatter.string(from: date)
        
        newQuiz.totalQuestions = Int32(totalQuestions)
        newQuiz.score = score
        newQuiz.quiz_id = quizID
        newQuiz.day_id = dayID
        newQuiz.isPassed = isPassed
        
        // Save the context.
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func CheckQuiz(quiz_id: Int32) -> Bool
    {
        var check = false
        let context = coreData.getContext()
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Quizzes", in: context)
        request.predicate = NSPredicate(format: "quiz_id == %ld", quiz_id)
        do
        {
            let result = try context.fetch(request)
            
            for r in result
            {
                let row = r as! NSManagedObject
                if(row.managedObjectContext != nil)
                {
                    check = true
                }
                else
                {
                    check = false
                }
            }
            
        }
        catch
        {
            
        }
        
        return check
    }
    
    func DeleteAllRecords()
    {
        let context = coreData.getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Quizzes")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func getQuizzesStats()->(Int, Int, Int, Int, Float, Double, String)
    {
        var takens = 0
        var questions = 0
        var answers = 0
        var score = 0
        var overallScore = 0
        var winRate = 0.0
        var correctAnswerPerQuestion = 0.0
        var badge = "herald"
        let context = coreData.getContext()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Quizzes", in: context)
        
        do
        {
            let result = try context.fetch(request) as! [NSManagedObject]
            
            for r in result
            {
                let quize: Quizzes = r as! Quizzes
                takens += 1
                questions += Int(quize.totalQuestions)
                answers += Int(quize.score)/10 
                score += Int(quize.score)
                overallScore += Int(quize.score)
                winRate += Double(quize.isPassed)
            }
            if(winRate > 0)
            {
                winRate = Double((Float(winRate)/Float(takens)*100))
            }
            if(answers > 0 && questions > 0)
            {
                correctAnswerPerQuestion = Double(Float(answers)/Float(questions)*100)
            }
            
            if(score >= 0 && score <= 50)
            {
                badge = "herald"
            }
            if(score > 50  && score <= 100)
            {
                badge = "guardian"
            }
            if(score > 100 && score <= 150)
            {
                badge = "crusader"
            }
            if(score > 150 && score <= 200)
            {
                badge = "archon"
            }
            if(score > 200 && score <= 250)
            {
                badge = "legend"
            }
        }
        catch
        {
            
        }
        return (takens, questions, answers, overallScore, Float(winRate), correctAnswerPerQuestion, badge)
    }
}














