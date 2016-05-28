//
//  StudentDetailController.swift
//  On The Map
//
//  Created by Ricardo Griffith on 22/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

// Information Posting View:
class StudentDetailController : UIViewController, CLLocationManagerDelegate {
    // MARK: Outlets
    
    @IBOutlet weak var QuestionPart1: UILabel!
    @IBOutlet weak var QuestionPart2: UILabel!
    @IBOutlet weak var QuestionPart3: UILabel!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var displayMap: MKMapView!
    @IBOutlet weak var actionButton: UIButton!
    
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
        let geocoder = CLGeocoder()
        
        if (location.text != "") {
            geocoder.geocodeAddressString(location.text!) { (placemarks, error) -> Void in
                
                if let firstPlacemark = placemarks?[0] {
                    print(firstPlacemark)
                    
                    // DEBUG: Testing added a pin to the map.
                    let newYorkLocation = CLLocationCoordinate2DMake((firstPlacemark.location?.coordinate.latitude)!, (firstPlacemark.location?.coordinate.longitude)!)
                    // Drop a pin
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = newYorkLocation
                    dropPin.title = self.location.text!
                    self.displayMap.hidden = false
                    self.displayMap.addAnnotation(dropPin)
                }
            }
        }
    }
}