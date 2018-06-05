//
//  TaskManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 06/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import CoreData

class NoteManager
{
    let coreData = CoreDataManager()
    
    let defaults = UserDefaults.standard
    var day_id = Int()
    
    func AddNote(dayID: Int, note_title: String, note_content: String)
    {
        let context = coreData.getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)

        let note: Notes = NSManagedObject(entity: entity!, insertInto: context) as! Notes
        
        day_id = dayID
        
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let current = timeFormatter.string(from: time)
        
        note.note_id = getLastNoteID()
        note.day_id = Int32(day_id)
        note.note_title = note_title
        note.note_content = note_content
        note.note_add_time = current
        
        do
        {
            try context.save()
        }
        catch
        {
            
        }
    }
    
    func UpdateNote(noteID:Int32, note_content: String)
    {
        let context = coreData.getContext()
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        request.predicate = NSPredicate(format: "note_id == %ld", noteID)
        
        do
        {
            let result = try context.fetch(request)
            let note: Notes = result.first as! NSManagedObject as! Notes
            note.note_content = note_content
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
    }
    
    func getLastNoteID() -> Int32
    {
        var note_id = Int32()
        let context = coreData.getContext()
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        let sort = NSSortDescriptor(key: "note_id", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchLimit = 1
        
        let keypathExpression = NSExpression(forKeyPath: "note_id")
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
                    note_id = Int32(r[key]!) + 1
                }
            }
            else
            {
                note_id = 1
            }
        }
        catch
        {
        }

        return note_id
    }
    
    func getNotes(dayID: Int) -> ([Notes])
    {
        var notes: [Notes] = [Notes]()
        let context = coreData.getContext()
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.predicate = NSPredicate(format: "day_id == %ld", Int32(dayID))
        request.entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        request.returnsObjectsAsFaults = false
        //request.resultType = NSFetchRequestResultType.dictionaryResultType
        
        do
        {
            let result = try context.fetch(request)
            
            for note in result as! [NSManagedObject]
            {
                notes.append(note as! Notes)
            }
        }
        catch
        {
            
        }
        
        return (notes)
    }
    
    func NotesOfDay(dayId: Int) -> Int
    {
        var total = 0
        
        total = getNotes(dayID: dayId).count
        
        return total
    }
}




