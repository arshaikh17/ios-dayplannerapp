//
//  QuizManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 17/05/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import CoreData

class PhotoManager
{
    let coreData = CoreDataManager()
    let defaults = UserDefaults.standard
    
    func saveImageInfo(_ assetURL:String, fileName:String, creationTime:String, day_id: Int32, title: String)
    {
        let context = coreData.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Images", in: context)
        let images: Images = NSManagedObject(entity: entity!, insertInto:context) as! Images
        
        images.image_url = assetURL
        images.image = fileName
        images.image_title = title
        images.day_id = day_id
        images.image_add_time = creationTime
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getPhotos(dayID: Int)->[Images]{
        var images: [Images] = [Images]()
        let context = coreData.getContext()

        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.predicate = NSPredicate(format: "day_id == %ld", Int32(dayID))
        request.entity = NSEntityDescription.entity(forEntityName: "Images", in: context)
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                images.append(data as! Images)
            }
            
        } catch {
            
            print("Failed")
        }
        return images
    }
    
    
    func PhotosOfDay(dayId: Int) -> Int
    {
        var total = 0
        
        total = getPhotos(dayID: dayId).count
        
        return total
    }
}















