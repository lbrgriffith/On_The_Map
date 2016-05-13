//
//  UdacityClient.swift
//  On The Map
//
//  Created by Ricardo Griffith on 12/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}