//
//  UdacityClient.swift
//  On The Map
//
//  Created by Ricardo Griffith on 12/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient : NSObject {
    // MARK: Properties
    
    // authentication state
    var accountRegistered: Bool = false
    var accountKey: String!
    var sessionID: String!
    var sessionExpiration: NSDate!
    
    // shared session
    var session = NSURLSession.sharedSession()
    
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