//
//  StudentDetailController.swift
//  On The Map
//
//  Created by Ricardo Griffith on 22/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import UIKit

// Information Posting View:
class StudentDetailController : UIViewController {
    // MARK: Outlets
    
    @IBOutlet weak var QuestionPart1: UILabel!
    @IBOutlet weak var QuestionPart2: UILabel!
    @IBOutlet weak var QuestionPart3: UILabel!
    
    //MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        let backItem = UIBarButtonItem()
        backItem.title = Constants.ToolBarLabel.Cancel
        backItem.target = self
        backItem.action = #selector(StudentDetailController.cancel)
        navigationItem.rightBarButtonItem = backItem
        
        QuestionPart1.font = UIFont(name: Constants.FontFace.RobotoThin, size: Constants.FontFace.RobotoDetailSize)
        QuestionPart2.font = UIFont(name: Constants.FontFace.RobotoMedium, size: Constants.FontFace.RobotoDetailSize)
        QuestionPart3.font = UIFont(name: Constants.FontFace.RobotoThin, size: Constants.FontFace.RobotoDetailSize)
    }
    
    // MARK: Actions
    
    func cancel() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        
    }
}