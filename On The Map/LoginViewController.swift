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
    
    // Properties
    var client = UdacityClient.sharedInstance()
    var keyboardOnScreen = false
    
    // MARK: Storyboard References
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var messagesField: UILabel!
    
    // Local variables
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: Constants.Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: Constants.Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: Constants.Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: Constants.Selectors.KeyboardDidHide)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func login(sender: AnyObject) {
        if (usernameField.text != "" && passwordField.text != "") {
            /* 1. Set the parameters */
            
            var username: String!
            var password: String!
            
            if let optionalUsername = usernameField.text {
                username = "\(optionalUsername)"
            }
            if let optionalPassword = passwordField.text {
                password = "\(optionalPassword)"
            }
            
            /* 2. Get a session Id from udacity by using the user's login credentials */
            getSessionID(username, password: password)
        }
        else {
            messagesField.text = Constants.Messages.MissingUsernameAndPassword
        }
    }
    
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
        let task = client.session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return;
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= Constants.UdacitySessionResult.MinimumSuccessCode && statusCode <= Constants.UdacitySessionResult.MaximumSuccessCode else {
                displayError("Your request returned a status code other than 2xx!")
                return;
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return;
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
            
            // Parse the account information
            if let accountInformation = parsedResult[Constants.UdacitySessionResult.Account] as? [String:AnyObject] {
                let registered = accountInformation[Constants.UdacitySessionResult.Registered] as! Int
                if (registered == 1) {
                    self.client.accountRegistered = true
                }
                else {
                    self.client.accountRegistered = false
                }
                
                self.client.accountKey = (accountInformation[Constants.UdacitySessionResult.Key] as? String)!
                
                // Parse the Session information.
                if let accountInformation = parsedResult[Constants.UdacitySessionResult.Session] as? [String:AnyObject] {
                    let registered = accountInformation[Constants.UdacitySessionResult.Id] as! String
                    self.client.sessionID = registered
                    
                    let DateFormatter = NSDateFormatter()
                    DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                    self.client.sessionExpiration = DateFormatter.dateFromString(accountInformation[Constants.UdacitySessionResult.Expiration]! as! String)
                    
                    self.completeLogin()
                }
            }
        }
        
        /* 5. Start the request */
        task.resume()
    }
    
    // MARK: Helper Functions
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            messagesField.text = errorString
        }
    }
    
    // MARK: Login
    
    private func completeLogin() {
        performUIUpdatesOnMain {
          self.messagesField.text = ""
          let controller = self.storyboard!.instantiateViewControllerWithIdentifier("StudentInformationNavigator") as! UINavigationController
          self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // Reistration: Send the user to the registration page.
    @IBAction func register(sender: UIButton) {
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.Registration
        UIApplication.sharedApplication().openURL(components.URL!)
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    private func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        configureTextField(usernameField)
        configureTextField(passwordField)
    }
    
    private func configureTextField(textField: UITextField) {
        let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .Always
        textField.delegate = self
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(usernameField)
        resignIfFirstResponder(passwordField)
    }
}

// MARK: - LoginViewController (Notifications)

extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

