//
//  StateCodes.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/27/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

enum StateCodes: Int {
    case GA
    case NC
    
    var shortDescription: String {
        switch self {
        case .GA:
            return "GA"
        case .NC:
            return "NC"
        }
    }
    
    var description: String {
        switch self {
        case .GA:
            return "Georgia"
        case .NC:
            return "North Carolina"
        }
    }
    
    static var count: Int {
        var count = 0
        while let _ = self.init(rawValue: count) { count += 1 }
        return count
    }
    
    static func getStateCode(index: Int) -> StateCodes {
        return self.init(rawValue: index)!
    }
    
    static func getIndexForState(state: String) -> Int {
        var index = 0
        while let _ = self.init(rawValue: index) {
            let stateCode = getStateCode(index)
            if state == stateCode.shortDescription {
                return index
            }
            index += 1
        }
        
        return 0
    }
    
}
