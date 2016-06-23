//
//  Address.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/22/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import Gloss

struct Address: Decodable, Glossy {
    var street: String?
    var aptSuite: String?
    var city: String?
    var state: String?
    var zipCode: String?
    
    var oneLineDescription: String {
        if aptSuite != nil {
            return "\(street!) \(aptSuite!) \(city!), \(state!) \(zipCode!)"
        } else {
            return "\(street!) \(city!), \(state!) \(zipCode!)"
        }
    }
    
    var multiLineDescription: String {
        if aptSuite != nil {
            return "\(street!)\n\(aptSuite!)\n\(city!), \(state!) \(zipCode!)"
        } else {
            return "\(street!)\n\(city!), \(state!) \(zipCode!)"
        }
    }
    
    init(street: String?, aptSuite: String?, city: String?, state: String?, zipCode: String?) {
        self.street = street
        self.aptSuite = aptSuite
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
    
    init?(json: JSON) {
        guard let address: JSON = json else {
            return nil
        }
        
        street = "street" <~~ address
        aptSuite = "aptSuite" <~~ address
        city = "city" <~~ address
        state = "state" <~~ address
        zipCode = "zipCode" <~~ address
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "street" ~~> street,
            "aptSuite" ~~> aptSuite,
            "city" ~~> city,
            "state" ~~> state,
            "zipCode" ~~> zipCode
            ])
    }
}
