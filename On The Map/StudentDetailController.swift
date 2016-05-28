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
    @IBOutlet weak var blueBackground: UILabel!
    @IBOutlet weak var urlTextField: UITextView!
    
    // MARK: Properties
    
    var client = UdacityClient.sharedInstance()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var firstName: String!
    var lastName: String!
    
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

        getPublicUserData(client.accountKey)
    }
    
    // MARK: Actions
    
    func cancel() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        let geocoder = CLGeocoder()
        
        if (actionButton.titleLabel?.text != Constants.ControlLabel.Submit) {
            geocoder.geocodeAddressString(location.text!) { (placemarks, error) -> Void in
                if let firstPlacemark = placemarks?[0] {
                    //print(firstPlacemark)
                    
                    // DEBUG: Testing added a pin to the map.
                    
                    self.latitude = (firstPlacemark.location?.coordinate.latitude)!
                    self.longitude = (firstPlacemark.location?.coordinate.longitude)!
                    
                    let newYorkLocation = CLLocationCoordinate2DMake(self.latitude, self.longitude)
                    // Drop a pin
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = newYorkLocation
                    dropPin.title = self.location.text!
                    // Show the map
                    self.displayMap.hidden = false
                    self.displayMap.addAnnotation(dropPin)
                    
                    // Hide the input controls.
                    self.QuestionPart1.hidden = true
                    self.QuestionPart2.hidden = true
                    self.QuestionPart3.hidden = true
                    self.blueBackground.hidden = true
                    self.location.hidden = true
                    self.urlTextField.hidden = false
                    
                    self.actionButton.setTitle(Constants.ControlLabel.Submit, forState: UIControlState.Normal)
                    self.actionButton.titleLabel?.textAlignment = NSTextAlignment.Center
                }
            }
        } else {
            // TODO: Submit to the service
            let components = NSURLComponents()
            components.scheme = Constants.Parse.ApiScheme
            components.host = Constants.Parse.ApiHost
            components.path = Constants.Parse.ApiPath
            let request = NSMutableURLRequest(URL: components.URL!)
            
            request.HTTPMethod = Constants.URLRequest.MethodPOST
            request.addValue(Constants.Parse.ApplicationID, forHTTPHeaderField: Constants.Parse.ApplicationIDHTTPHeader)
            request.addValue(Constants.Parse.RESTAPIKey, forHTTPHeaderField: Constants.Parse.RESTAPIHTTPHeader)
            request.addValue(Constants.URLRequest.ApplicationTypeJSON, forHTTPHeaderField: Constants.URLRequest.ContentType)
            request.HTTPBody = "{\"uniqueKey\": \"\(client.accountKey)\", \"firstName\": \"\(self.firstName)\", \"lastName\": \"\(self.lastName)\",\"mapString\": \"\(location.text! as String)\", \"mediaURL\": \"\(urlTextField.text as String)\",\"latitude\": \(self.latitude), \"longitude\": \(self.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
            let task = client.session.dataTaskWithRequest(request) { data, response, error in
                // if an error occurs, print it and re-enable the UI
                func displayError(error: String, debugLabelText: String? = nil) {
                    print(error)
                }
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    displayError("There was an error with your request: \(error)")
                    return;
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= Constants.UdacitySessionResult.MinimumSuccessCode && statusCode <= Constants.UdacitySessionResult.MaximumSuccessCode else {
                    displayError("Your request returned a status code other than 2xx!")
                    return;
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    displayError("No data was returned by the request!")
                    return;
                }
                
                /* 4. Parse the data */
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    displayError("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                performUIUpdatesOnMain({
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            }
            task.resume()
        }
    }
    
    // MARK: Methods
    
    func getPublicUserData(userId: String)
    {
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = "\(Constants.Udacity.GetUsers)\(userId)"
        
        let request = NSMutableURLRequest(URL: components.URL!)
        
        let task = client.session.dataTaskWithRequest(request) { data, response, error in
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return;
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= Constants.UdacitySessionResult.MinimumSuccessCode && statusCode <= Constants.UdacitySessionResult.MaximumSuccessCode else {
                displayError("Your request returned a status code other than 2xx!")
                return;
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return;
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // Parse the account information
            if let accountInformation = parsedResult["user"] as? [String:AnyObject] {
                self.lastName = (accountInformation["last_name"] as? String)!
                self.firstName = (accountInformation["first_name"] as? String)!
            }
        }
        
        task.resume()
    }
}