//
//  MessageServices.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/16/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class MessageServices: AnyObject {
    
    class func displayMessage(title: String, message: String, presentingViewController viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okButton)
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
