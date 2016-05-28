//
//  MapViewController.swift
//  On The Map
//
//  Created by Ricardo Griffith on 20/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import MapKit
import AddressBook
import UIKit

class MapViewController : UIViewController {
    
    // MARK: Outlets and Properties
    @IBOutlet var studentMap: MKMapView!
    var client = UdacityClient.sharedInstance()
    var locations: [StudentLocation] = [StudentLocation]()
    
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentMap.delegate = self
        
        let logoutItem = UIBarButtonItem()
        logoutItem.title = Constants.ToolBarLabel.LogOut
        logoutItem.target = self
        logoutItem.action = #selector(MapViewController.logout)
        
        navigationItem.leftBarButtonItem = logoutItem
        
        getStudentLocations()
    }
    
    // MARK: Helper Functions
    
    func logout() {
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath
        let request = NSMutableURLRequest(URL: components.URL!)
        
        request.HTTPMethod = Constants.URLRequest.MethodDELETE
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Constants.URLRequest.CookieName { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Constants.URLRequest.CookieName)
        }
        let task = client.session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            self.completeLogout()
        }
        
        task.resume()
    }
    
    private func completeLogout() {
        performUIUpdatesOnMain {
            let nextViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as UIViewController
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
    }
}

// MARK: Entension

extension MapViewController: MKMapViewDelegate {
    // MARK: Get Student Locations
    
    func getStudentLocations() {
        let components = NSURLComponents()
        components.scheme = Constants.Parse.ApiScheme
        components.host = Constants.Parse.ApiHost
        components.path = Constants.Parse.ApiPath
        components.queryItems = [NSURLQueryItem]()
        let queryItem = NSURLQueryItem(name: Constants.Parse.LimitKey, value: Constants.Parse.LimitValue)
        components.queryItems!.append(queryItem)
        let request = NSMutableURLRequest(URL: components.URL!)
        
        request.addValue(Constants.Parse.ApplicationID, forHTTPHeaderField: Constants.Parse.ApplicationIDHTTPHeader)
        request.addValue(Constants.Parse.RESTAPIKey, forHTTPHeaderField: Constants.Parse.RESTAPIHTTPHeader)
        
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
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print(Constants.Messages.Not200)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError(Constants.Messages.NoData)
                return;
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            if let parsedData = parsedResult["results"] as? [[String:AnyObject]] {
                let StudentLocations = StudentLocation.locationsFromResults(parsedData)
                for studentlocation in StudentLocations {
                    performUIUpdatesOnMain({
                    let Coordinate = CLLocationCoordinate2DMake(studentlocation.latitude as CLLocationDegrees, studentlocation.longitude as CLLocationDegrees)
                    // Drop a pin
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = Coordinate
                    dropPin.title = "\(studentlocation.firstName) \(studentlocation.lastName)"
                    self.studentMap.addAnnotation(dropPin)})
                }
            }
        }
        
        task.resume()
    }
}