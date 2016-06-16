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
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user {
                DataReference.sharedInstance.setUserProfile(user)
            }
            self.activityIndicator.stopAnimating()
            self.performSegueWithIdentifier("LaunchToMapSegue", sender: nil)
        })
    }

}
