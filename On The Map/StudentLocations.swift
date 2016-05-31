//
//  StudentLocations.swift
//  On The Map
//
//  Created by Ricardo Griffith on 31/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import Foundation

class StudentLocations: NSObject {
    // MARK: Properties
    static var RetrievedStudentLocations: [StudentLocation] = [StudentLocation]()
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> StudentLocations {
        struct Singleton {
            static var sharedInstance = StudentLocations()
        }
        return Singleton.sharedInstance
    }
}