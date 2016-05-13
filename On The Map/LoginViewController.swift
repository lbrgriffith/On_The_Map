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
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func login(sender: AnyObject) {
    }
}

