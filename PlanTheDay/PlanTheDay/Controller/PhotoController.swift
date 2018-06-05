//
//  PhotoController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 27/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit
import Photos
import CoreData

class PhotoController: UIViewController
{
    let coreData = CoreDataManager()
    var context: NSManagedObjectContext!
    
    let photoManager = PhotoManager()
    
    @IBOutlet var pickedImageView: UIImageView!
    @IBOutlet var fileNameLabel: UITextField!
    var day_id = Int()
    let defaults = UserDefaults.standard
    
    var assetURL: String = "", fileName: String = "", creationTime: String = "", imageTitle: String = ""

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        day_id = Int(defaults.string(forKey: "fetch_id")!)!
        context = coreData.getContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func onSavePhotoButtonTap(_ sender: Any) {
        photoManager.saveImageInfo(assetURL, fileName: fileName, creationTime: creationTime, day_id: Int32(day_id), title: imageTitle)
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name("refreshViews"), object: nil)
        })
    }
}

extension PhotoController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let url = info[UIImagePickerControllerReferenceURL] as? URL {
            assetURL = url.absoluteString
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            if let firstAsset = assets.firstObject{
                if let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                    fileName = firstResource.originalFilename
                }
                if let date = firstAsset.creationDate{
                    creationTime = date.toString(dateFormat: "dMMyyyySSS")
                }
            }
        }

        fileNameLabel.text = fileName
        pickedImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
     
        if let txtT = fileNameLabel
        {
            imageTitle = txtT.text!
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}


