//
//  Profile.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation
import Gloss
import CoreLocation

struct Profile: Decodable, Glossy {
    var id: String?
    var name: String?
    var address: Address?
    var location: CLLocationCoordinate2D?
    var yardSales: [String: Bool]?
    var bookmarks: [String: Bool]?
    
    init(){
        id = DataServices.currentUser?.uid
    }
    
    init?(json: JSON) {
        id = "id" <~~ json
        name = "name" <~~ json
        if let addressJSON: JSON = "address" <~~ json {
            address = Address(json: addressJSON)
        }
        if let latitude: Double = "latitude" <~~ json, let longitude: Double = "longitude" <~~ json {
            location = CLLocationCoordinate2DMake(latitude, longitude)
        }
        yardSales = "yardSales" <~~ json
        bookmarks = "bookmarks" <~~ json
    }
    
    func toJSON() -> JSON? {
        let latitude = location?.latitude
        let longitude = location?.longitude
        
        return jsonify([
            "id" ~~> id,
            "name" ~~> name,
            "address" ~~> address?.toJSON(),
            "latitude" ~~> latitude,
            "longitude" ~~> longitude,
            "yardSales" ~~> yardSales,
            "bookmarks" ~~> bookmarks,
        ])
    }
}