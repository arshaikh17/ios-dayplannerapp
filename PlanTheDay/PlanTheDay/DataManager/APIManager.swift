//
//  APIManager.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 03/05/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import Foundation
import UIKit
class APIManager
{
    func getData(completionBlock: @escaping (Data) -> Void)
    {
        let requestURL = URL(string: "https://ialirasheed.com/api/quiz/new_quiz/")
        var request = URLRequest(url: requestURL!)
        
        request.httpMethod = "GET"
        //request.httpBody = qMes.data(using: .utf8)
        
        let requestTask = URLSession.shared.dataTask(with: request) 
        {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if(error != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                
                _  = String(data: data!, encoding: String.Encoding.utf8) as String!
                
                completionBlock(data!);
                
            }
        }
        requestTask.resume()
    }
    
}
