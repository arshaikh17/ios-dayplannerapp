//
//  TaskController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 06/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit
import CoreData

class TaskController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableTask: UITableView?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtTask: UITextView!
    let defaults = UserDefaults.standard
    let taskManager = TaskManager()
    let alert = AlertController()
    var day_id = Int()
    var event:Any?
    let coreData = CoreDataManager()
    
    var allTasks:[Tasks] = [Tasks]()
    
    var today_id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //day_id = Int(defaults.string(forKey: "day_id")!)!
        //print(defaults.string(forKey: "fetch_id"))
        day_id = Int(defaults.string(forKey: "fetch_id")!)!
        today_id = Int(defaults.string(forKey: "day_id")!)!
        allTasks = taskManager.getTasks(dayID: day_id)
        // Do any additional setup after loading the view.
        
        
        if(allTasks.count > 0)
        {
            if let table = tableTask
            {
                table.delegate = self
                table.dataSource = self
            }
        }
    }
    
    func editTaskContent(_ index: Int){
        let alertController = UIAlertController(title: "Edit task \n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        
        let rect        = CGRect(x:15, y:50, width:240, height:150.0)
        let textView    = UITextView(frame: rect)
        
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        
        textView.text = self.allTasks[index].task_content!
        alertController.view.addSubview(textView)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            self.taskManager.UpdateTask(taskID: self.allTasks[index].task_id, taskTitle: self.allTasks[index].task_title!, taskContent: textView.text, taskProgess:self.allTasks[index].task_completion, taskTime: self.allTasks[index].task_add_time!)
            
            self.allTasks = self.taskManager.getTasks(dayID: self.day_id)
            
            self.tableTask?.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return allTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskCell = tableTask?.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCellView
        
        taskCell.lblTaskTitle.text = "\(allTasks[indexPath.row].task_title!)"
        taskCell.txtTaskContent.text = allTasks[indexPath.row].task_content!
        taskCell.sldrTaskProgress.value = allTasks[indexPath.row].task_completion
        taskCell.lblTaskTime.text = "@ " + allTasks[indexPath.row].task_add_time!
        
        taskCell.sldrTaskProgress.tag = Int(allTasks[indexPath.row].task_id)
        taskCell.sldrTaskProgress.addTarget(self, action: #selector(self.ProgressSliderChanged), for: .valueChanged)
        
        if(day_id != today_id)
        {
            taskCell.sldrTaskProgress.isEnabled = false
        }
        
        return taskCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editTaskContent(indexPath.row)
    }
    
    @objc func ProgressSliderChanged(sender: UISlider)
    {
        guard let cell = sender.superview?.superview as? TaskCellView else {
            return
        }
        
        let indexPath = tableTask?.indexPath(for: cell)
        
        taskManager.UpdateTask(taskID: self.allTasks[(indexPath?.row)!].task_id, taskTitle: self.allTasks[(indexPath?.row)!].task_title!, taskContent: self.allTasks[(indexPath?.row)!].task_content!, taskProgess:sender.value, taskTime: self.allTasks[(indexPath?.row)!].task_add_time!)
        NotificationCenter.default.post(name: Notification.Name("refreshViews"), object: nil)
    }
    
    @IBAction func btnAddTask(_ sender: Any)
    {
        let day_id = Int(defaults.string(forKey: "day_id")!)
        
        let title = txtTitle.text
        let content = txtTask.text
        
        if(title != "" && content != "")
        {
            taskManager.AddTask(dayID: day_id!, task_title: title!, task_content: content!)
            txtTitle.text = ""
            txtTask.text = ""
            
            dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("refreshViews"), object: nil)
            })
            //  alert.SimpleAlert(title: "Hurray!", message: "Task added.", buttonTitle: "Back", fromController: self)
        }
        else
        {
            alert.SimpleAlert(title: "Fill all fields", message: "Task title and task content must be filled.", buttonTitle: "Okay", fromController: self)
        }
    }
}
