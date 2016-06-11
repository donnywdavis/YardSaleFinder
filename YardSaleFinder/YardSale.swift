//
//  YardSale.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation
import Gloss
import CoreLocation

struct YardSale: Decodable, Glossy {
    var id: String?
    var address: String?
    var location: CLLocationCoordinate2D
    var annotation: Annotation?
    var fromTime: NSDate?
    var toTime: NSDate?
    var items: [String]?
    var fromPrice: Double?
    var toPrice: Double?
    var photos: [String]?
    var created: NSDate?
    
    init?(json: JSON) {
        id = "id" <~~ json
        address = "address" <~~ json
        location = CLLocationCoordinate2DMake(("latitude" <~~ json)!, ("longitude" <~~ json)!)
        annotation = Annotation(title: "Yard Sale", subtitle: address, coordinate: location)
        fromTime = NSDate.dateFromString("fromTime" <~~ json)
        toTime = NSDate.dateFromString("toTime" <~~ json)
        items = "items" <~~ json
        fromPrice = "fromPrice" <~~ json
        toPrice = "toPrice" <~~ json
        photos = "photos" <~~ json
        created = NSDate.dateFromString("created" <~~ json)
    }
    
    func toJSON() -> JSON? {
        let latitude = location.latitude
        let longitude = location.longitude
        let fromTime = String.stringFromDate(self.fromTime)
        let toTime = String.stringFromDate(self.toTime)
        
        return jsonify([
            "id" ~~> id,
            "address" ~~> address,
            "laitude" ~~> latitude,
            "longitude" ~~> longitude,
            "fromTime" ~~> fromTime,
            "toTime" ~~> toTime,
            "items" ~~> items,
            "fromPrice" ~~> fromPrice,
            "toPrice" ~~> toPrice,
            "photos" ~~> photos,
            "created" ~~> created
        ])
    }

}