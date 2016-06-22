//
//  Address.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/22/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

struct Address {
    var street: String
    var aptSuite: String?
    var city: String
    var state: String
    var zipCode: Int
    
    var oneLineDescription: String {
        if aptSuite != nil {
            return "\(street) \(aptSuite) \(city), \(state) \(zipCode)"
        } else {
            return "\(street) \(city), \(state) \(zipCode)"
        }
    }
    
    var multiLineDescription: String {
        if aptSuite != nil {
            return "\(street)\n\(aptSuite)\n\(city), \(state) \(zipCode)"
        } else {
            return "\(street)\n\(city), \(state) \(zipCode)"
        }
    }
}
