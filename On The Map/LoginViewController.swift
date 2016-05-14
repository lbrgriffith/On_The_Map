//
//  LoginViewController.swift
//  On The Map
//
//  Created by Ricardo Griffith on 11/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var messagesField: UILabel!
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func login(sender: AnyObject) {
        if (usernameField.text != "" && passwordField.text != "") {
            getSessionID()
        }
        else {
            messagesField.text = "You must enter both username and password!"
        }
    }
    
    private func getSessionID() {
        /* 1. Set the parameters */
        var Client = UdacityClient()
        
        /* 2/3. Build the URL, Configure the request */
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath
        let request = NSMutableURLRequest(URL: components.URL!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(usernameField.text)\", \"password\": \"\(passwordField.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = Client.session.dataTaskWithRequest(request) { (data, response, error) in
            
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
            
            /* 5. Parse the data */
            //parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))

        }
        
        /* 7. Start the request */
        task.resume()
    }
}

