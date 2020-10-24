//
//  SignInViewController.swift
//  Step Out
//
//  Created by Mac on 8/20/20.
//  Copyright © 2020 Bexultan. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {
    @IBOutlet var signInButtonGoogle: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}
