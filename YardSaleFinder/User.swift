//
//  User.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation
import Gloss
import CoreLocation

struct User: Decodable {
    var id: String?
    var name: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var yardSales: [String]?
    let created: NSDate?
    
    init?(json: JSON) {
        id = "id" <~~ json
        name = "name" <~~ json
        address = "address" <~~ json
        latitude = "latitude" <~~ json
        longitude = "longitude" <~~ json
        yardSales = "yardSales" <~~ json
        created = NSDate.dateFromString("created" <~~ json)
    }
}