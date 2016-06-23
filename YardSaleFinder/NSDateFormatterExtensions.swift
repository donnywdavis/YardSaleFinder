//
//  NSDateFormatterExtensions.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/17/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    
    func formatDate(date: NSDate?) -> String? {
        guard let date = date else {
            return nil
        }
        
        self.setLocalizedDateFormatFromTemplate("EEEE MMM d, yyyy")
        
        return self.stringFromDate(date)
    }
    
    func formatTime(date: NSDate?) -> String? {
        guard let date = date else {
            return nil
        }
        
        self.setLocalizedDateFormatFromTemplate("hh:mm")
        
        return self.stringFromDate(date)
    }
    
}
