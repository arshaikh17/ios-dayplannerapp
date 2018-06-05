//
//  TaskManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 06/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import CoreData

class TaskManager
{
    let coreData = CoreDataManager()
    
    let defaults = UserDefaults.standard
    var day_id = Int()
    
    func AddTask(dayID: Int, task_title: String, task_content: String)
    {
        let context = coreData.getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        let task: Tasks = NSManagedObject(entity: entity!, insertInto: context) as! Tasks
        
        day_id = dayID
        
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let current = timeFormatter.string(from: time)
        
        task.task_id = getLastTaskID()
        task.day_id = Int32(day_id)
        task.task_title = task_title
        task.task_content = task_content
        task.task_add_time = current
        task.task_completion = 0.0
        
        do
        {
            try context.save()
        }
        catch
        {
            
        }
    }
    
    func getLastTaskID() -> Int32
    {
        var task_id = Int32()
        let context = coreData.getContext()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)

        request.resultType = NSFetchRequestResultType.dictionaryResultType

        let sort = NSSortDescriptor(key: "task_id", ascending: false)

        request.sortDescriptors = [sort]
        request.fetchLimit = 1
    
        let keypathExpression = NSExpression(forKeyPath: "task_id")

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
                    task_id = Int32(r[key]!) + 1
   
                }
            }
            else
            {
                task_id = 1

            }
        }
        catch
        {
        }

        return task_id
    }
    
    func getTasks(dayID: Int) -> ([Tasks])
    {
        let context = coreData.getContext()
        var tasks: [Tasks] = [Tasks]()

        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.predicate = NSPredicate(format: "day_id == %ld", Int32(dayID))
        request.entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        request.returnsObjectsAsFaults = false
        //request.resultType = NSFetchRequestResultType.dictionaryResultType
        do
        {
            let result = try context.fetch(request)
            
            for task in result as! [NSManagedObject]
            {
                tasks.append(task as! Tasks)
            }
        }
        catch
        {
            
        }
        
        return (tasks)
    }
    
    func UpdateTask(taskID: Int32, taskTitle: String, taskContent: String, taskProgess: Float, taskTime: String)
    {
        let context = coreData.getContext()
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        request.predicate = NSPredicate(format: "task_id == %ld", taskID)
        
        do
        {
            let result = try context.fetch(request)
            let task: Tasks =  result.first as! NSManagedObject as! Tasks
            
            task.task_title = taskTitle
            task.task_content = taskContent
            task.task_add_time = taskTime
            task.task_completion = taskProgess
           
            do
            {
                try context.save()
            }
            catch
            {
                
            }
        }
        catch
        {
            
        }
        print(taskProgess)
    }
    
    func TasksProgress(dayId: Int) -> (String, String, Int)
    {
        var completed = 0
        var total = 0
        var average = 0
        
        let tasks:[Tasks] = getTasks(dayID: dayId)
        
        total = tasks.count
        for task in tasks
        {
            let tt = Int(task.task_completion)
            if(tt == 100)
            {
                completed += 1
            }
            average += tt
        }
        if(average > 0)
        {
            average = average/total
        }
        else
        {
            average = 0
        }
    
        return (String(completed), String(total), Int(average))
    }
}


