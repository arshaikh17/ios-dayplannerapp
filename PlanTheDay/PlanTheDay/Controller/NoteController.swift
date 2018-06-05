//
//  NoteController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 06/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit
import CoreData

class NoteController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableNotes: UITableView?
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    let noteManager = NoteManager()
    let alert = AlertController()
    var day_id = Int()
    var event:Any?
    let coreData = CoreDataManager()
    let defaults = UserDefaults.standard
    var note_id = Int32()

    var content = String()
    var time = String()
    
    var today_id = Int()
    var notes: [Notes] = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        day_id = Int(defaults.string(forKey: "day_id")!)!

        notes = noteManager.getNotes(dayID: day_id)
        
        if let table = tableNotes
        {
            table.delegate = self
            table.dataSource = self
        }
    }
    
    @IBAction func btnAddNote(_ sender: Any)
    {
        let day_id = Int(defaults.string(forKey: "day_id")!)!
        let title = txtTitle.text
        let content = txtNote.text
        
        if(title != "" && content != "")
        {
            noteManager.AddNote(dayID: day_id, note_title: title!, note_content: content!)
            txtTitle.text = ""
            txtNote.text = ""
            
            dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("refreshViews"), object: nil)
            })

//            alert.SimpleAlert(title: "Hurray!", message: "Note to this day, added.", buttonTitle: "Back", fromController: self)
        }
        else
        {
            alert.SimpleAlert(title: "Fill all fields", message: "Note title and Note content must be filled.", buttonTitle: "Okay", fromController: self)
        }
    }
    
    func editNoteContent(_ index: Int){
        let alertController = UIAlertController(title: "Edit note \n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        
        let rect        = CGRect(x:15, y:50, width:240, height:150.0)
        let textView    = UITextView(frame: rect)
        
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        
        textView.text = self.notes[index].note_content
        alertController.view.addSubview(textView)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            self.noteManager.UpdateNote(noteID: self.notes[index].note_id, note_content: textView.text)
            
            self.notes = self.noteManager.getNotes(dayID: self.day_id)

            self.tableNotes?.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableNotes?.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCellView
        
        cell.lblNoteTime.text = notes[indexPath.row].note_add_time
        cell.lblNoteTitle.text = notes[indexPath.row].note_title
        cell.txtNoteContent.text = notes[indexPath.row].note_content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editNoteContent(indexPath.row)
    }
}

