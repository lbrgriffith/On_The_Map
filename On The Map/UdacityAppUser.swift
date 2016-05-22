//
//  UdacityAppUser.swift
//  On The Map
//
//  Created by Ricardo Griffith on 22/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import Foundation
import MapKit

class UdacityAppUser : NSObject, MKAnnotation {
    // MARK: Properties
    
    let pinTitle: String
    let location: String
    let hyperlink: NSURL
    let coordinate: CLLocationCoordinate2D
    
    // MARK: Initializers
    
    init(titlePin: String, locationName: String, hyperlink: NSURL, coordinate: CLLocationCoordinate2D) {
        self.pinTitle = titlePin
        self.location = locationName
        self.hyperlink = hyperlink
        self.coordinate = coordinate
        
        super.init()
    }
}