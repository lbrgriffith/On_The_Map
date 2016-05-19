//
//  Constants.swift
//  On The Map
//
//  Created by Ricardo Griffith on 13/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import UIKit

// MARK: - Udacity Constants

struct Constants {
    // MARK: General app constants
    struct Messages {
        static let MissingUsernameAndPassword = "You must enter both username and password!"
    }
    
    // MARK: General
    struct URLRequest {
        static let MethodPOST = "POST"
        static let MethodGET = "GET"
        static let ApplicationTypeJSON = "application/json"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    // MARK: Udacity
    struct Udacity {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
    }
    
    // MARK: Udacity Parameter Keys
    struct UdacitySessionResult {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
    }
    
    // MARK: Selectors
    struct Selectors {
        static let KeyboardWillShow: Selector = Selector("keyboardWillShow:")
        static let KeyboardWillHide: Selector = Selector("keyboardWillHide:")
        static let KeyboardDidShow: Selector = Selector("keyboardDidShow:")
        static let KeyboardDidHide: Selector = Selector("keyboardDidHide:")
    }
}