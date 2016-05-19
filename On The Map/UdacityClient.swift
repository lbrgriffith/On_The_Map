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
    var accountRegistered: Bool = false
    var accountKey: String = ""
    var sessionID: String? = nil
    var sessionExpiration: NSDate? = nil
    
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
    
    // MARK: Login
    func getSessionID(username: String, password: String) {
        /* 1/2. Build the URL, Configure the request */
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath
        let request = NSMutableURLRequest(URL: components.URL!)
        
        request.HTTPMethod = Constants.URLRequest.MethodPOST
        request.addValue(Constants.URLRequest.ApplicationTypeJSON, forHTTPHeaderField: Constants.URLRequest.Accept)
        request.addValue(Constants.URLRequest.ApplicationTypeJSON, forHTTPHeaderField: Constants.URLRequest.ContentType)
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 3. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 4. Parse the data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            if let accountInformation = parsedResult["account"] as? [String:AnyObject] {
                    let registered = accountInformation["registered"] as! Int
                        if (registered == 1) {
                            self.accountRegistered = true
                        }
                        else {
                            self.accountRegistered = false
                        }
                    
                    self.accountKey = (accountInformation["key"] as? String)!
                print(self.accountKey)
            }
        }
        
        /* 5. Start the request */
        task.resume()
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}