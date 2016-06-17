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
    var address: String?
    var location: CLLocationCoordinate2D?
    var yardSales: [String: Bool]?
    var profilePhotoUpdated: Bool?
    
    init(){
        id = DataReference.sharedInstance.currentUser?.uid
        name = nil
        address = nil
        location = nil
        yardSales = nil
        profilePhotoUpdated = nil
    }
    
    init?(json: JSON) {
        id = "id" <~~ json
        name = "name" <~~ json
        address = "address" <~~ json
        if let latitude: Double = "latitude" <~~ json, let longitude: Double = "longitude" <~~ json {
            location = CLLocationCoordinate2DMake(latitude, longitude)
        }
        yardSales = "yardSales" <~~ json
        profilePhotoUpdated = "profilePhotoUpdated" <~~ json
    }
    
    func toJSON() -> JSON? {
        let latitude = location?.latitude
        let longitude = location?.longitude
        
        return jsonify([
            "id" ~~> id,
            "name" ~~> name,
            "address" ~~> address,
            "latitude" ~~> latitude,
            "longitude" ~~> longitude,
            "yardSales" ~~> yardSales,
            "profilePhotoUpdated" ~~> profilePhotoUpdated,
        ])
    }
}