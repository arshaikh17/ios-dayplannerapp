//
//  DaysManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 29/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DaysManager
{
    let coreData = CoreDataManager()
    let defaults = UserDefaults.standard
    
    func CheckDayID(dayID: Int) -> (Bool, Bool)
    {
        var check = Bool()
        var status = Bool()
        //var days = Days()
        var fetchID = Int()
        let context = coreData.getContext()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Days", in: context)
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        let sort = NSSortDescriptor(key: "day_id", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchLimit = 1
        
        let keypathExpression = NSExpression(forKeyPath: "day_id")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])
        
        let key = "maxID"
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = key
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer32AttributeType
        
        request.propertiesToFetch = [expressionDescription]
        
        do
        {
            let result = try context.fetch(request) as? [[String: Int32]]
            let result1 = result!
            if(result1.count > 0)
            {
                for r in result1
                {
                    fetchID = Int(r[key]!)
                }
                if(fetchID == dayID)
                {
                    status = true
                    check = true
                }
                else
                {
                    status = true
                    check = false
                }
            }
            else
            {
                status = true
                check = false
            }
        }
        catch
        {
            status = false
            check = false
        }
        return (status, check)
    }
    
    func getDayImage(day: String) -> String
    {
        var image = String()
        
        if(day == "Monday")
        {
            image = "monday"
        }
        else if(day == "Saturday")
        {
            image = "saturday"
        }
        else if(day == "Sunday")
        {
            image = "sunday"
        }
        else if(day == "Friday")
        {
            image = "friday"
        }
        else if(day == "Thursday")
        {
            image = "thursday"
        }
        else if(day == "Tuesday")
        {
            image = "tuesday"
        }
        else if(day == "Wednesday")
        {
            image = "wednesday"
        }
        
        return image
    }
    
    func AddDay(dayID: Int)
    {
        let context = coreData.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Days", in: context)
        let newDays: Days = NSManagedObject(entity: entity!, insertInto: context) as! Days
        
        let date = Date()
        let formatter = DateFormatter()
        
        newDays.setValue(dayID, forKey: "day_id")
        
        formatter.dateFormat = "EEEE"
        newDays.day_name = formatter.string(from: date)
        
        formatter.dateFormat = "dd"
        newDays.day_day = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        newDays.day_month = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy"
        newDays.day_year = Int32(formatter.string(from: date))!
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func DeleteAllRecords()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func DayImages()
    {
        let context = coreData.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Day_images", in: context)
        let day: Day_images = NSManagedObject(entity: entity!, insertInto: context) as! Day_images
        
        let day_images = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        let day_names = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        var count = 1
        var counter = 0
        for image in day_images
        {
            day.dm_id = Int32(count)
            day.day_image = image
            day.day_name = day_names[counter]
            
            count += 1
            counter += 1
            
            do
            {
                try context.save()
            }
            catch
            {
                
            }
        }
    }
    
    func getDayID() -> Int
    {
        var id = Int()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        id = Int(formatter.string(from: date))!
        
        return id
    }
}
