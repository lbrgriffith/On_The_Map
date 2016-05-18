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
    struct UdacityParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Udacity Response Keys
    struct UdacityResponseKeys {
        static let Title = "title"
        static let ID = "id"
        static let PosterPath = "poster_path"
        static let StatusCode = "status_code"
        static let StatusMessage = "status_message"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Success = "success"
        static let UserID = "id"
        static let Results = "results"
    }
    
    // MARK: Selectors
    struct Selectors {
        static let KeyboardWillShow: Selector = Selector("keyboardWillShow:")
        static let KeyboardWillHide: Selector = Selector("keyboardWillHide:")
        static let KeyboardDidShow: Selector = Selector("keyboardDidShow:")
        static let KeyboardDidHide: Selector = Selector("keyboardDidHide:")
    }
}