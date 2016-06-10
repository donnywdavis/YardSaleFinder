//
//  DateExtensions.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation


extension NSDate {
    
    class func dateFromString(string: String?) -> NSDate? {
        guard let string = string else {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        return dateFormatter.dateFromString(string)
    }
    
}