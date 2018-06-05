//
//  CoreDataManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 29/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager
{
    func getContext() -> NSManagedObjectContext
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = delegate.persistentContainer.viewContext as NSManagedObjectContext
        
        return context
    }
    
    func deleteAllRecords(entity: String)
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
