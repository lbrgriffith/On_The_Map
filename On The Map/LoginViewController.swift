//
//  LoginViewController.swift
//  On The Map
//
//  Created by Ricardo Griffith on 11/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class LoginViewController : UIViewController {
    
    // MARK: Properties
    
    var client = UdacityClient.sharedInstance()
    var keyboardOnScreen = false
    
    // MARK: Storyboard References
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var messagesField: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(LoginViewController.keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(LoginViewController.keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(LoginViewController.keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(LoginViewController.keyboardDidHide))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Actions
    
    @IBAction func login(sender: AnyObject) {
        if (usernameField.text != "" && passwordField.text != "") {
            /* 2. Get a session Id from udacity by using the user's login credentials */
            getSessionID(usernameField.text! as String, password: passwordField.text! as String)
        }
        else {
            messagesField.text = Constants.Messages.MissingUsernameAndPassword
        }
    }
    
    // MARK: Methods
    
    func getSessionID(username: String, password: String) {
        /* Build the URL, Configure the request */
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.ApiPath
        let request = NSMutableURLRequest(URL: components.URL!)
        
        request.HTTPMethod = Constants.URLRequest.MethodPOST
        request.addValue(Constants.URLRequest.ApplicationTypeJSON, forHTTPHeaderField: Constants.URLRequest.Accept)
        request.addValue(Constants.URLRequest.ApplicationTypeJSON, forHTTPHeaderField: Constants.URLRequest.ContentType)
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Check if connected to the network before request.
        if LoginViewController.isConnectedToNetwork() == true {
            print("Internet connection - Available")
        } else {
            print("Internet connection - Not Available")
            displayAlert("No Internet Connection", message: "Make sure your phone is connected to the internet.")
        }
        
        /* Make the request */
        let task = client.session.dataTaskWithRequest(request) { (data, response, error) in
            /* if an error occurs, print it and re-enable the UI */
            func displayError(error: String, debugLabelText: String? = nil) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                if (error!.code == Constants.UdacitySessionResult.NetworkErrorCode) {
                    performUIUpdatesOnMain( {
                        self.displayAlert(Constants.Alert.InternetUnavailable, message:
                        Constants.Alert.InternetUnavailableMessage)
                    })
                }
                return;
            }
            
            /* GUARD: Did we get a response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= Constants.UdacitySessionResult.MinimumSuccessCode && statusCode <= Constants.UdacitySessionResult.MaximumSuccessCode else {
                displayError(Constants.Messages.Not200)
                
                let currentStatusCode = (response as? NSHTTPURLResponse)?.statusCode

                if (currentStatusCode == Constants.UdacitySessionResult.Forbidden403) {
                    performUIUpdatesOnMain( {
                        self.displayAlert(Constants.Alert.LoginFailed, message: Constants.Alert.LoginFailedMessage)
                    })
                }
                return;
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError(Constants.Messages.NoData)
                return;
            }
            
            /* Parse the data - subset response data! */
            let newData = data.subdataWithRange(NSMakeRange(Constants.UdacitySessionResult.Skip, data.length - Constants.UdacitySessionResult.Skip))
            
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
                    DateFormatter.dateFormat = Constants.Dates.Format
                    self.client.sessionExpiration = DateFormatter.dateFromString(accountInformation[Constants.UdacitySessionResult.Expiration]! as! String)
                    
                    self.completeLogin()
                }
            }
        }
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
          let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabNav") as! UITabBarController
          self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // Registration: Send the user to the registration page.
    @IBAction func register(sender: UIButton) {
        let components = NSURLComponents()
        components.scheme = Constants.Udacity.ApiScheme
        components.host = Constants.Udacity.ApiHost
        components.path = Constants.Udacity.Registration
        UIApplication.sharedApplication().openURL(components.URL!)
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
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
    
    func displayAlert(title: String, message: String) {
        let controller = UIAlertController()
        controller.title = title
        controller.message = message
        // Dismiss the view controller after the user taps “ok”
        let okAction = UIAlertAction (title:Constants.Alert.ButtonText, style: UIAlertActionStyle.Default) {
            action in self.dismissViewControllerAnimated(true, completion: nil) }
        controller.addAction(okAction)
        self.presentViewController(controller, animated: true, completion:nil)
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

