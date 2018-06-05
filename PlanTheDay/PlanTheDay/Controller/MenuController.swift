//
//  MenuController.swift
//  PlanTheDay
//
//  Created by Ali Rasheed on 05/04/2018.
//  Copyright © 2018 ArtisticDevelopers. All rights reserved.
//

import UIKit

class MenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func change () {
        let objMC: MoodController? = MoodController()
        let aObjNavi = UINavigationController(rootViewController: objMC!)
        self.present(aObjNavi, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
