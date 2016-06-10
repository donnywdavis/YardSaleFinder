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

struct User: Decodable, Glossy {
    var id: String?
    var name: String?
    var address: String?
    var location: CLLocationCoordinate2D
    var yardSales: [String: Bool]?
    let created: NSDate?
    
    init?(json: JSON) {
        id = "id" <~~ json
        name = "name" <~~ json
        address = "address" <~~ json
        location = CLLocationCoordinate2DMake(("latitude" <~~ json)!, ("longitude" <~~ json)!)
        yardSales = "yardSales" <~~ json
        created = NSDate.dateFromString("created" <~~ json)
    }
    
    func toJSON() -> JSON? {
        let latitude = location.latitude
        let longitude = location.longitude
        
        return jsonify([
            "id" ~~> id,
            "name" ~~> name,
            "address" ~~> address,
            "latitude" ~~> latitude,
            "longitude" ~~> longitude,
            "yardSales" ~~> yardSales,
            "created" ~~> created
        ])
    }
}