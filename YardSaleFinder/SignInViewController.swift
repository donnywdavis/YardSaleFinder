//
//  SignInViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.text = ""
        passwordTextField.text = ""
        
        signInButton.layer.cornerRadius = 5
        signInButton.enabled = true

        // Set up a gesture to dismiss the keyboard when tapping outside of a text field
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap(_:)))
        dismissKeyboardTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboardTap)
    }

}

// MARK: Button Actions

extension SignInViewController {
    
    @IBAction func signInButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            self.emailTextField.becomeFirstResponder()
            MessageServices.displayMessage("Invalid Signin", message: "Could not sign in. Please check your email and password.", presentingViewController: self)
            return
        }
        
        signInButton.enabled = false
        signInButton.setTitle("", forState: .Normal)
        activityIndicator.startAnimating()
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (userInfo, error) in
            guard error == nil else {
                self.signInButton.setTitle("Sign In", forState: .Normal)
                self.signInButton.enabled = true
                self.activityIndicator.stopAnimating()
                self.emailTextField.becomeFirstResponder()
                MessageServices.displayMessage("Invalid Signin", message: "Could not sign in. Please check your email and password.", presentingViewController: self)
                return
            }
            
            DataServices.updateCurrentUser(userInfo!)
            DataServices.getRemoteProfileData(userInfo!.uid, completion: { (userProfile) in
                DataServices.updateUserProfile(userProfile!)
                
                DataServices.downloadProfileImage(userProfile!.id!, toPath: NSURL(fileURLWithPath: DirectoryServices.getImagePath()), completion: { (url, error) in
                    self.signInButton.setTitle("Sign In", forState: .Normal)
                    self.signInButton.enabled = true
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("SignInToProfileSegue", sender: nil)
                })
            })
        })
    }
    
}

// MARK: Gesture Functions

extension SignInViewController {
    
    func dismissKeyboardOnTap(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

// MARK: Text Field Delegates

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder() {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
            signInButtonTapped()
        }
        return true
    }
    
}