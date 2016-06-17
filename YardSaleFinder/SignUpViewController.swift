//
//  SignUpViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.enabled = true
        
        // Set up a gesture to dismiss the keyboard when tapping outside of a text field
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap(_:)))
        dismissKeyboardTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboardTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: Button Actions

extension SignUpViewController {
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let passwordConfirmation = confirmPasswordTextField.text else {
            return
        }
        
        guard password == passwordConfirmation else {
            MessageServices.displayMessage("Passwords Don't Match", message: "Passwords entered do not match.", presentingViewController: self)
            return
        }
        
        activityIndicator.startAnimating()
        signUpButton.enabled = false
        signUpButton.setTitle("", forState: .Normal)
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (userInfo, error) in
            guard error == nil else {
                self.activityIndicator.stopAnimating()
                MessageServices.displayMessage("Error on Create", message: "There was a problem creating the account.", presentingViewController: self)
                return
            }
            
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (userInfo, error) in
                self.activityIndicator.stopAnimating()
                
                guard error == nil else {
                    MessageServices.displayMessage("Invalid Signin", message: "Could not sign in. Please check your email and password.", presentingViewController: self)
                    return
                }
                
                self.performSegueWithIdentifier("SignUpToProfileSegue", sender: nil)
                
            })
        })
    }
    
}

// MARK: Gesture Functions

extension SignUpViewController {
    
    func dismissKeyboardOnTap(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

