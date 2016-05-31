//
//  StudentAnnotation.swift
//  On The Map
//
//  Created by Ricardo Griffith on 30/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import MapKit

class StudentAnnotation: NSObject, MKAnnotation {
    let name: String
    let url: String
    let coordinate: CLLocationCoordinate2D
    
    init(studentName: String, studentUrl: String, coordinate: CLLocationCoordinate2D) {
        self.name = studentName
        self.url = studentUrl
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return url
    }
}