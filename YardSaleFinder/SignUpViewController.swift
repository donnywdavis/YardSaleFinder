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
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        
        signUpButton.layer.cornerRadius = 5
        
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
            displayMessage("Passwords Don't Match", message: "Passwords entered do not match.")
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (userInfo, error) in
            guard error == nil else {
                self.displayMessage("Error on Create", message: "There was a problem creating the account.")
                return
            }
            
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (userInfo, error) in
                guard error == nil else {
                    self.displayMessage("Invalid Signin", message: "Could not sign in. Please check your email and password.")
                    return
                }
                
                self.performSegueWithIdentifier("SignUpToProfileSegue", sender: nil)
                
            })
        })
    }
    
}

// MARK: Error Messages

extension SignUpViewController {
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okButton)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

// MARK: Gesture Functions

extension SignUpViewController {
    
    func dismissKeyboardOnTap(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

