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
    
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentMap.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func logout(sender: UIBarButtonItem) {
        let authenticatedUser = UdacityClient()
        authenticatedUser.logOut()
    }
    
    
    // MARK: Map Methods
    
    func getUserLocation () {
        
    }
    
    // MARK: Helper Functions
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                               regionRadius * Constants.Mapping.RadiusMultiplier, regionRadius * Constants.Mapping.RadiusMultiplier)
        studentMap.setRegion(coordinateRegion, animated: true)
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