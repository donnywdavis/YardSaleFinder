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
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.enabled = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        // Set up a gesture to dismiss the keyboard when tapping outside of a text field
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap(_:)))
        dismissKeyboardTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

// MARK: Button Actions

extension SignUpViewController {
    
    @IBAction func signUpButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let passwordConfirmation = confirmPasswordTextField.text else {
            MessageServices.displayMessage("Incorrect email or password field", message: "Please check that the email and password fields have valid info entered and try again.", presentingViewController: self)
            return
        }
        
        guard email != "" && password != "" && passwordConfirmation != "" else {
            MessageServices.displayMessage("Invalid Entry", message: "Email and/or password fields cannot be blank. Enter valid values and try again.", presentingViewController: self)
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
                self.signUpButton.setTitle("Sign Up", forState: .Normal)
                return
            }
            
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (userInfo, error) in
                self.activityIndicator.stopAnimating()
                
                guard error == nil else {
                    MessageServices.displayMessage("Invalid Signin", message: "Could not sign in. Please check your email and password.", presentingViewController: self)
                    self.signUpButton.setTitle("Sign Up", forState: .Normal)
                    return
                }
                
                DataServices.updateCurrentUser(userInfo!)
                DataServices.getRemoteProfileData(userInfo!.uid, completion: { (userProfile) in
                    DataServices.updateUserProfile(userProfile!)
                    self.performSegueWithIdentifier("SignUpToProfileSegue", sender: nil)
                })
                
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

// MARK: Text Field Delegates

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder() {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if confirmPasswordTextField.isFirstResponder() {
            confirmPasswordTextField.resignFirstResponder()
            signUpButtonTapped()
        }
        return true
    }
    
}

// MARK: Keyboard Notifications

extension SignUpViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size else {
            return
        }
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if emailTextField.isFirstResponder() {
            scrollView.scrollRectToVisible(emailTextField.frame, animated: true)
        } else if passwordTextField.isFirstResponder() {
            scrollView.scrollRectToVisible(passwordTextField.frame, animated: true)
        } else if confirmPasswordTextField.isFirstResponder() {
            scrollView.scrollRectToVisible(confirmPasswordTextField.frame, animated: true)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
}

