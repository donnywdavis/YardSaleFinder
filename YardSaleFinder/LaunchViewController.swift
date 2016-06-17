//
//  LaunchViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/16/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var authListener: FIRAuthStateDidChangeListenerHandle?
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        
        authListener = FIRAuth.auth()!.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user {
                if DataReference.sharedInstance.currentUser == nil {
                    DataReference.sharedInstance.setUserProfile(user)
                    DataReference.sharedInstance.profileImageRef.writeToFile(NSURL(fileURLWithPath: DirectoryServices.getImagePath())) { (url, error) in
                        if error != nil && DirectoryServices.profileImageExists() {
                            DirectoryServices.removeImage()
                        }
                        self.activityIndicator.stopAnimating()
                        self.performSegueWithIdentifier("LaunchToMapSegue", sender: nil)
                    }
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.performSegueWithIdentifier("LaunchToMapSegue", sender: nil)
            }
        })
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAuth.auth()?.removeAuthStateDidChangeListener(authListener!)
    }
}
