//
//  SavedPhotosController.swift
//  PlanTheDay
//
//  Created by Mostafizur Rahman on 5/19/18.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit
import Photos

class SavedPhotosController: UIViewController {
    
    @IBOutlet var photosCollectionView: UICollectionView!
    
    let photoManager = PhotoManager()
    var day_id = Int()
    var photos: [Images] = [Images]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        day_id = Int(defaults.string(forKey: "day_id")!)!
        photos = photoManager.getPhotos(dayID:day_id )
        photosCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUIImagefromAsseturlAndSetToImageView (urlString: String, imageView: UIImageView) {
        
        let url = URL(string: urlString)
        let asset = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
        
        if let result = asset.firstObject{
            PHImageManager.default().requestImageData(for: result, options: nil, resultHandler: {(_ rawData: Data?, _ dataUTI: String?, _ orientation: UIImageOrientation, _ info: [AnyHashable: Any]?) -> Void in
                imageView.image = UIImage(data: rawData!)
            })
        }
    }
}


extension SavedPhotosController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let cellImageView: UIImageView = cell.contentView.viewWithTag(10) as! UIImageView
        self.getUIImagefromAsseturlAndSetToImageView(urlString: photos[indexPath.item].image_url!, imageView: cellImageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = self.photosCollectionView.frame.size.width-25
        let cellWidth = availableWidth/2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    
}
