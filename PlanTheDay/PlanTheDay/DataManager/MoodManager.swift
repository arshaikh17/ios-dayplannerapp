//
//  MoodManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 30/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import CoreData

class MoodManager
{
    let coreData = CoreDataManager()
    let defaults = UserDefaults.standard
    var day_id = Int()
    
    func AddMood(moodValue: Float, moodTime: String)
    {
        let date = Date()
        let formatter = DateFormatter()
        
        day_id = Int(defaults.string(forKey: "day_id")!)!
        let context = coreData.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Moods", in: context)
        let mood: Moods = NSManagedObject(entity: entity!, insertInto: context) as! Moods
        formatter.dateFormat = "hhmmssSSS";
        let mood_id = String(day_id) + formatter.string(from: date)
        mood.mood_id = Int64(mood_id)!
        mood.day_id = Int32(day_id)
        mood.mood = Int32(moodValue)
        mood.mood_add_time = moodTime
        do
        {
            try context.save()
        }
        catch
        {
            
        }
    }
    
    func MapMood(mood: Float) -> (String, String, String)
    {
        var m = String()
        var i = String()
        var q = String()
        
        if(mood == 1)
        {
            m = "Ultra Happy"
            i = "happy_teeth"
            q = "Random quote mate"
        }
        else if(mood == 2)
        {
            m = "Very Happy"
            i = "happy1"
            q = "Random quote mate"
        }
        else if(mood == 3)
        {
            m = "Happy"
            i = "happy2"
            q = "Random quote mate"
        }
        else if(mood == 4)
        {
            m = "Goood"
            i = "sad4"
            q = "Random quote mate"
        }
        else if(mood == 5)
        {
            m = "Just well"
            i = "happy3"
            q = "Random quote mate"
        }
        else if(mood == 6)
        {
            m = "In moods"
            i = "confused"
            q = "Random quote mate"
        }
        else if(mood == 7)
        {
            m = "Angry"
            i = "angry"
            q = "Random quote mate"
        }
        else if(mood == 8)
        {
            m = "Sad"
            i = "sad3"
            q = "Random quote mate"
        }
        else if(mood == 9)
        {
            m = "Irritated"
            i = "sad2"
            q = "Random quote mate"
        }
        else if(mood == 10)
        {
            m = "Devastated"
            i = "sad1"
            q = "Random quote mate"
        }
        else if(mood == 11)
        {
            m = "Pathetic"
            i = "sad4"
            q = "Random quote mate"
        }
        else if(mood == 12)
        {
            m = "God Help"
            i = "sad5"
            q = "Random quote mate"
        }
        return (m, i, q)
    }
    
    func getMoods(dayId: Int) -> ([Moods])
    {
        print("DAY ID FROM GETMOODS()")
        print(dayId)
        var moods: [Moods] = [Moods]()
        let context = coreData.getContext()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Moods", in: context)
        request.predicate = NSPredicate(format: "day_id == %ld", Int32(dayId))
        print("Day ID From getMoods()")
        print(dayId)
        do
        {
            let result = try context.fetch(request)
            
            if(result.count > 0)
            {
                for mood in result as! [NSManagedObject]
                {
                    moods.append(mood as! Moods)
                }
            }
        }
        catch
        {
        }
        
        return (moods)
    }
    
    func MoodProgress(dayId: Int) -> (String, String)
    {
        var image = String()
        var mood = String()
        
        let moods:[Moods] = getMoods(dayId: dayId)
        
        var count = 0
        //print(moods)
        if(moods.count > 0)
        {
            for m in moods
            {
                count += Int(m.mood)
            }
            count = count/moods.count
            let final_mood = MapMood(mood: Float(count))
            image = final_mood.1
            mood = final_mood.0
        }
        else
        {
            image = "happy3"
            mood = "Going good. so far"
        }
        
        return (image, mood)
    }
}
