//
//  DetailViewController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 29/03/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var floaty = Floaty()
    let coreData = CoreDataManager()
    var day_id = Int32()
    let defaults = UserDefaults.standard
    let dayManager = DaysManager()
    let taskManager = TaskManager()
    let photoManager = PhotoManager()
    let moodManager = MoodManager()
    let noteManager = NoteManager()
    let quizManager = QuizManager()
    
    var image = String()
    
    @IBOutlet weak var taskProgressView: UICircularProgressRingView?
    @IBOutlet weak var lblTaskCount: UILabel?

    @IBOutlet weak var imgBanner: UIImageView!
    
    @IBOutlet weak var moodView: UIImageView?
    @IBOutlet weak var lblMood: UILabel?
    @IBOutlet weak var stackViewButtons: UIStackView!
    
    @IBOutlet weak var lblNoteCount: UILabel?
    
    @IBOutlet weak var lblQuizTaken: UILabel?
    @IBOutlet weak var lblQuestionsAttempted: UILabel?
    @IBOutlet weak var lblAnsweredCorrectly: UILabel?
    @IBOutlet weak var lblQuizOverallScore: UILabel?
    @IBOutlet weak var lblQuizWinRate: UILabel?
    @IBOutlet weak var lblCorrectAnswerPerQuestion: UILabel?
    @IBOutlet weak var lblPictureCount: UILabel!
    
    @IBOutlet weak var imgTrophy: UIImageView?
    @IBOutlet weak var btnTakeQuiz: UIButton?
    func configureView()
    {
        // Update the user interface for the detail item.
        if let detail = detailItem
        {
            image = detail.day_name!.description
            day_id = detail.day_id
            defaults.set(String(day_id), forKey: "day_id")

            let fetch_day = Int32(detail.day_id.description)!
            defaults.setValue(fetch_day, forKey: "fetch_id")

            if(day_id != fetch_day)
            {
                stackViewButtons?.isHidden = true
            }
            else
            {
                stackViewButtons?.isHidden = false
            }
            
            let taskProgress = taskManager.TasksProgress(dayId: Int(fetch_day))
            print(taskProgress)
            
            let completed = taskProgress.0
            let total = taskProgress.1
            let average = taskProgress.2
            
            let cnt = completed.description + "/" + total.description
  
            if let taskCount = lblTaskCount
            {
                taskCount.text = cnt
            }
            if let taskProgress = taskProgressView
            {
                taskProgress.value = CGFloat(average)
            }
            if(image != "")
            {
                if let img = imgBanner
                {
                    img.image = UIImage(named: dayManager.getDayImage(day: image))!
                }
            }
            let photos = photoManager.PhotosOfDay(dayId: Int(fetch_day))
            if let lblphotos = lblPictureCount
            {
                lblphotos.text = String(photos)
            }
            let moodProgress = moodManager.MoodProgress(dayId: Int(fetch_day))
            if let lblM = lblMood
            {
                lblM.text = moodProgress.1
            }
            if let imgM = moodView
            {
                imgM.image = UIImage(named: moodProgress.0)
            }
            let notes = noteManager.NotesOfDay(dayId: Int(fetch_day))
            if let lblNote = lblNoteCount
            {
                lblNote.text = String(notes)
            }
            
            let quizStats = quizManager.getQuizzesStats()
            if let lblQT = lblQuizTaken
            {
                lblQT.text = String(quizStats.0)
            }
            if let lblQA = lblQuestionsAttempted
            {
                lblQA.text = String(quizStats.1)
            }
            if let lblAC = lblAnsweredCorrectly
            {
                lblAC.text = String(quizStats.2)
            }
            if let lblQOS = lblQuizOverallScore
            {
                lblQOS.text = String(quizStats.3)
            }
            if let lblQWR = lblQuizWinRate
            {
                lblQWR.text = String(quizStats.4) + "%"
            }
            if let lblCAPQ = lblCorrectAnswerPerQuestion
            {
                lblCAPQ.text = String(quizStats.5) + "%"
            }
            if let imgB = imgTrophy
            {
                imgB.image = UIImage(named: quizStats.6)
            }
            if let btnTQ = btnTakeQuiz
            {
                if(day_id != fetch_day)
                {
                    btnTQ.isHidden = true
                }
                else
                {
                    btnTQ.isHidden = false
                }
            }
            
        }
        
    }
    var data2:Data?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViews), name: Notification.Name("refreshViews"), object: nil)

        
        refreshViews()
    }
    
    @objc func refreshViews() {
        api.getData()
            {
                (data)   in
                self.data2 = data
        }
        // Do any additional setup after loading the view, typically from a nib.
        if(isKeyPresentInUserDefaults(key: "fetch_id") == false)
        {
            MakeViewInvisible()
        }
        else
        {
            MakeViewVisible()
            configureView()
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func MakeViewInvisible()
    {
        view.viewWithTag(101)?.isHidden = true
        view.viewWithTag(102)?.isHidden = true
        view.viewWithTag(103)?.isHidden = true
        view.viewWithTag(104)?.isHidden = true
        //view.viewWithTag(105)?.isHidden = true
        
        let lblStatsTitle = (view.viewWithTag(105) as? UILabel)
        if let lbl = lblStatsTitle
        {
            lbl.text = "Select the day"
            lbl.textAlignment = .center
        }
        
        view.viewWithTag(106)?.isHidden = true
        view.viewWithTag(107)?.isHidden = true
        view.viewWithTag(108)?.isHidden = true
        view.viewWithTag(109)?.isHidden = true
        view.viewWithTag(110)?.isHidden = true
        view.viewWithTag(111)?.isHidden = true
        view.viewWithTag(112)?.isHidden = true
        view.viewWithTag(113)?.isHidden = true
        view.viewWithTag(114)?.isHidden = true
    }
    
    func MakeViewVisible()
    {
        view.viewWithTag(101)?.isHidden = false
        view.viewWithTag(102)?.isHidden = false
        view.viewWithTag(103)?.isHidden = false
        view.viewWithTag(104)?.isHidden = false
        //view.viewWithTag(105)?.isHidden = false
        
        let lblStatsTitle = (view.viewWithTag(105) as? UILabel)
        if let lbl = lblStatsTitle
        {
            lbl.text = "Today's Statistics"
            lbl.textAlignment = .left
        }
        
        view.viewWithTag(106)?.isHidden = false
        view.viewWithTag(107)?.isHidden = false
        view.viewWithTag(108)?.isHidden = false
        view.viewWithTag(109)?.isHidden = false
        view.viewWithTag(110)?.isHidden = false
        view.viewWithTag(111)?.isHidden = false
        view.viewWithTag(112)?.isHidden = false
        view.viewWithTag(113)?.isHidden = false
        view.viewWithTag(114)?.isHidden = false
    }
    
    let api = APIManager()
    @IBAction func btnada(_ sender: Any)
    {
        if let usableData = data2 {
            do {
                
                let jsonArray = try JSONSerialization.jsonObject(with: usableData)  as! [String:AnyObject]
                
            } catch {
                print("JSON Processing Failed")
            }
        }
        else
        {
            print("JSON Processing Failed2")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Days? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

