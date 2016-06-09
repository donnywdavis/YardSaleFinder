//
//  StringExtensions.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation


extension String {
    
    static func stringFromDate(date: NSDate?) -> String? {
        guard let date = date else {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        return dateFormatter.stringFromDate(date)
    }
    
}