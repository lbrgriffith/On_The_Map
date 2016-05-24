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
    
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentMap.delegate = self
        
        // DEBUG:
        let newYorkLocation = CLLocationCoordinate2DMake(32.3078, -64.7505)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "Hamilton, Bermuda"
        studentMap.addAnnotation(dropPin)
        
        // get user data 
        getPublicUserData((client.accountKey)!)
    }
    
    // MARK: Actions
    
    @IBAction func logout(sender: UIBarButtonItem) {
        logOut()
    }
    
    // MARK: Helper Functions
    
    func getPublicUserData(userId: String)
    {
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = "\(Constants.Udacity.GetUsers)\(userId)"
        print(components.path)
        let request = NSMutableURLRequest(URL: components.URL!)
        
        let task = client.session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                print(error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                               regionRadius * Constants.Mapping.RadiusMultiplier, regionRadius * Constants.Mapping.RadiusMultiplier)
        studentMap.setRegion(coordinateRegion, animated: true)
    }
    
    func logOut() {
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
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
}

// MARK: Entension

extension MapViewController: MKMapViewDelegate {
    // MARK: Annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UdacityAppUser {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
}