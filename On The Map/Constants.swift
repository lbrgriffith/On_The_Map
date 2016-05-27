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
    
    // MARK: Toolbar
    struct ToolBarLabel {
        static let LogOut = "Log Out"
        static let Cancel = "Cancel"
    }
    
    // MARK: General
    
    struct URLRequest {
        static let MethodPOST = "POST"
        static let MethodGET = "GET"
        static let MethodDELETE = "DELETE"
        static let ApplicationTypeJSON = "application/json"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let CookieName = "X-XSRF-TOKEN"
    }
    
    // MARK: Udacity
    
    struct Udacity {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
        static let Registration = "/account/auth#!/signup"
        static let GetUsers = "/api/users/"
    }
    
    // MARK: Udacity Parameter Keys
    
    struct UdacitySessionResult {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
        static let MinimumSuccessCode = 200
        static let MaximumSuccessCode = 299
    }
    
    // MARK: Parse API Constants
    
    struct Parse {
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes/StudentLocation"
        static let LimitValue = "100"
        static let LimitKey = "limit"
        static let ApplicationIDHTTPHeader = "X-Parse-Application-Id"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIHTTPHeader = "X-Parse-REST-API-Key"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: Fonts
    
    struct FontFace {
        static let RobotoThin = "Roboto-Thin"
        static let RobotoNormal = "Roboto-Regular"
        static let RobotoMedium = "Roboto-Medium"
        static let RobotoDetailSize: CGFloat = 20
    }
    
    struct Mapping {
        static let RadiusMultiplier = 2.0
    }
    
    // MARK: Selectors
    
    struct Selectors {
        static let KeyboardWillShow: Selector = Selector("keyboardWillShow:")
        static let KeyboardWillHide: Selector = Selector("keyboardWillHide:")
        static let KeyboardDidShow: Selector = Selector("keyboardDidShow:")
        static let KeyboardDidHide: Selector = Selector("keyboardDidHide:")
    }
}