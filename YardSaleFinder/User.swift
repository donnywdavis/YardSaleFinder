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
    var profilePhotoURL: String?
    var name: String?
    var address: String?
    var location: CLLocationCoordinate2D?
    var yardSales: [String: Bool]?
    let created: NSDate?
    
    init(){
        id = nil
        profilePhotoURL = nil
        name = nil
        address = nil
        location = nil
        yardSales = nil
        created = nil
    }
    
    init?(json: JSON) {
        id = "id" <~~ json
        name = "name" <~~ json
        if let photoUrl = DataReference.sharedInstance.currentUser?.photoURL {
            profilePhotoURL = String(photoUrl)
        } else {
            profilePhotoURL = nil
        }
        address = "address" <~~ json
        if let latitude: Double = "latitude" <~~ json, let longitude: Double = "longitude" <~~ json {
            location = CLLocationCoordinate2DMake(latitude, longitude)
        }
        yardSales = "yardSales" <~~ json
        created = NSDate.dateFromString("created" <~~ json)
    }
    
    func toJSON() -> JSON? {
        let latitude = location!.latitude
        let longitude = location!.longitude
        
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