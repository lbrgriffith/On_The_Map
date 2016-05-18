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
    // MARK: Storyboard References
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var messagesField: UILabel!
    
    // Local variables
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: Actions
    
    @IBAction func login(sender: AnyObject) {
        if (usernameField.text != "" && passwordField.text != "") {
            /* 1. Set the parameters */
            let Client = UdacityClient()
            
            var username = ""
            var password = ""
            
            if let optionalUsername = usernameField.text {
                username = "\(optionalUsername)"
            }
            if let optionalPassword = passwordField.text {
                password = "\(optionalPassword)"
            }
            
            /* 2. Get a session Id from udacity by using the user's login credentials */
            Client.getSessionID(username, password: password)
        }
        else {
            messagesField.text = Constants.Messages.MissingUsernameAndPassword
        }
    }
    
    // MARK: Helper Functions
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            messagesField.text = errorString
        }
    }
}

