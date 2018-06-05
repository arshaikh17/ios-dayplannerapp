//
//  MoodController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 30/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit

class MoodController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var moodTable: UITableView?
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet var viewMood: UIView!
    @IBOutlet weak var viewStars: CosmosView!
    @IBOutlet weak var btnUpdate: UIButton!
    let moodManager = MoodManager()
    var currentTime = String()
    //var time = Int()
    var day_id = Int()
    let defaults = UserDefaults.standard
    var mood:Float = 6
    var getMoods: [Moods] = [Moods]()
    
    @IBOutlet weak var navBarTop: UINavigationBar!
    //let aObjNavi = UINavigationController(rootViewController: objVC!)
    
    override func viewDidLoad()
    {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        currentTime = String(formatter.string(from: date))

        day_id = Int(defaults.string(forKey: "day_id")!)!

        getMoods = moodManager.getMoods(dayId: day_id)
        
            if let table = moodTable
            {
                table.delegate = self
                table.dataSource = self
            }
    }
    
    @IBAction func btnMood(_ sender: UIButton)
    {
        mood = Float(sender.tag)
        FlushButtonBackground()
        sender.backgroundColor = UIColor.gray
        
    }
    
    
    @IBOutlet var btnMoods: [UIButton]!
    func FlushButtonBackground()
    {
        for button in btnMoods
        {
            button.backgroundColor = UIColor.white
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnUpdateMood(_ sender: Any)
    {
        moodManager.AddMood(moodValue: Float(mood), moodTime: currentTime)
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name("refreshViews"), object: nil)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moodCell = moodTable?.dequeueReusableCell(withIdentifier: "moodCell", for: indexPath) as! MoodCellView
        
        moodCell.lblTime.text = "\(String(describing: getMoods[indexPath.row].mood_add_time!))"
        
        let moodMap = moodManager.MapMood(mood: Float(getMoods[indexPath.row].mood))
        print(moodMap)
        moodCell.lblMood.text = moodMap.0
        moodCell.lblQuote.text = moodMap.2
        moodCell.imgMood.image = UIImage(named: moodMap.1)
        
        return moodCell
    }
}
