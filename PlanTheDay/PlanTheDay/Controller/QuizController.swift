//
//  QuizController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 03/05/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit

class QuizController: UIViewController{

    let api = APIManager()
    var data:Data?
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var barProgress: UIProgressView!
    let defaults = UserDefaults.standard
    let quizManager = QuizManager()
    
    var day_id = Int32()
    var quiz_id = Int()
    
    var questionCount = 0
    var totalQUestions = 0
    
    var radioButtonController = SSRadioButtonsController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Quiz Section"
        day_id = Int32(Int(defaults.string(forKey: "day_id")!)!)
        Step1()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Step2()

        
        
    }
    
    func Step1()
    {
        view.viewWithTag(911)?.isHidden = false
        view.viewWithTag(912)?.isHidden = true
        view.viewWithTag(913)?.isHidden = true
        
        lblProgress.text = "Checking for a new quiz"
        barProgress.progress = 0.1
    }
    
    func Step2()
    {
        lblProgress.text = "Fetching Results"
        barProgress.progress = 0.4
        api.getData()
        {
                (output) in
                
                self.data = output
            
        }
        Step3()
    }
    
    func Step3()
    {
        var count:Int = 0
        while(data == nil)
        {
            if let d = data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: d) as! [String:AnyObject]
                    for d in json
                    {
                        if(d.key == "quiz_id")
                        {
                            quiz_id = Int(d.value as! Int32)
                        }
                    }
                    for d in json
                    {
                        if(d.key == "totalQuestions")
                        {
                            totalQUestions = d.value as! Int
                        }
                    }
                    for d in json
                    {
                        if(d.key == "status")
                        {
        
                            if(String(describing: d.value)
                                == "0")
                            {
                                lblProgress.text = "Sorry! No new quiz available at the moment"
                                barProgress.progress = 1
                            }
                            else
                            {
                              
                                let checker = quizManager.CheckQuiz(quiz_id: Int32(quiz_id))
                                print("S5")
                                if(checker == false)
                                {
                     
                                    lblProgress.text = "Starting Quiz!"
                                    barProgress.progress = 1
                                    sleep(3)
                                    
                                    Step4()
                                }
                                else
                                {
            
                                    lblProgress.text = "Sorry! No new quiz available at the moment"
                                    barProgress.progress = 1
                                }
                            }
                        }
                    }
                }
                catch
                {
                    
                }
            }
            count += 1
            //print(count)
        }
    }
    
    @IBOutlet weak var lblQuestionCount: UILabel!
    @IBOutlet weak var lblQuestionNo: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnAns1: UIButton!
    @IBOutlet weak var btnAns2: UIButton!
    @IBOutlet weak var btnAns3: UIButton!
    @IBOutlet weak var btnAns4: UIButton!
    
    func Step4()
    {
        view.viewWithTag(911)?.isHidden = true
        view.viewWithTag(912)?.isHidden = false
        view.viewWithTag(913)?.isHidden = true
        
        MapQuestion()
    }
    
    var currectCorrectAnswer = String()
    func MapQuestion()
    {
        var question = String()
        var answers = Array<String>()
        
        if let d = data
        {
            do
            {
                let json = try JSONSerialization.jsonObject(with: d) as! [String:AnyObject]
                
                for d in json
                {
                    let key = "question_" + String(questionCount)
                    
                    if(d.key == key)
                    {
                        question = (d.value as? String)!
                    }
                }
                for d in json
                {
                    if(d.key == "answer1_"+String(questionCount))
                    {
                        answers.append(d.value as! String)
                    }
                }
                for d in json
                {
                    if(d.key == "answer2_"+String(questionCount))
                    {
                        answers.append(d.value as! String)
                    }
                }
                for d in json
                {
                    if(d.key == "answer3_"+String(questionCount))
                    {
                        answers.append(d.value as! String)
                    }
                }
                for d in json
                {
                    if(d.key == "correctAnswer_"+String(questionCount))
                    {
                        answers.append(d.value as! String)
                        currectCorrectAnswer = d.value as! String
                    }
                }
            }
            catch
            {
                
            }
        }
        
        lblQuestionNo.text = "Question " + String(questionCount + 1)
        lblQuestion.text = question
        lblQuestionCount.text = "Question Left: "+String(questionCount+1)+"/"+String(totalQUestions)
        
        btnAns1.setTitle(answers[0], for: .normal)
        btnAns2.setTitle(answers[1], for: .normal)
        btnAns3.setTitle(answers[2], for: .normal)
        btnAns4.setTitle(answers[3], for: .normal)
        
        
    }

    var correctAnswers = 0
    @IBAction func btnAnswerChosen(_ sender: UIButton)
    {
        let answer = sender.currentTitle
        if(answer == currectCorrectAnswer)
        {
            correctAnswers += 1
        }
        questionCount += 1
        
        if(questionCount >= totalQUestions)
        {
            EndQuiz()
        }
        else
        {
            MapQuestion()
        }
    }
    
    @IBOutlet weak var lblCorrectAnswers: UILabel!
    func EndQuiz()
    {
        view.viewWithTag(911)?.isHidden = true
        view.viewWithTag(912)?.isHidden = true
        view.viewWithTag(913)?.isHidden = false
        var win = 0
        lblCorrectAnswers.text = "Correct Answers: " + String(correctAnswers) + " / " + String(totalQUestions)
        
        let score = correctAnswers * 10
        if(correctAnswers == 0)
        {
            win = 0
        }
        else
        {
            let s = totalQUestions/correctAnswers
            
            if(s > 1)
            {
                win = 1
            }
        }
        
        quizManager.SaveQuiz(dayID: Int32(day_id), totalQuestions: totalQUestions, quizID: Int32(quiz_id), score: Int32(score), isPassed: Int32(win))
    }
    
}
