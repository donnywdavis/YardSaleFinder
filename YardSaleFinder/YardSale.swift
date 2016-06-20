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
    var location: CLLocationCoordinate2D?
    var annotation: Annotation?
    var startTime: NSDate?
    var endTime: NSDate?
    var items: String?
    var fromPrice: Double?
    var toPrice: Double?
    var photos: [String]?
    var owner: String?
    var active: Bool?
    
    init() {
        owner = DataServices.currentUser?.uid
    }
    
    init?(json: JSON) {
        id = "id" <~~ json
        address = "address" <~~ json
        location = CLLocationCoordinate2DMake(("latitude" <~~ json)!, ("longitude" <~~ json)!)
        annotation = Annotation(title: "Yard Sale", subtitle: address, coordinate: location!, id: id)
        startTime = NSDate.dateFromString("startTime" <~~ json)
        endTime = NSDate.dateFromString("endTime" <~~ json)
        items = "items" <~~ json
        fromPrice = "fromPrice" <~~ json
        toPrice = "toPrice" <~~ json
        photos = "photos" <~~ json
        owner = "owner" <~~ json
        active = "active" <~~ json
    }
    
    func toJSON() -> JSON? {
        let latitude = location!.latitude
        let longitude = location!.longitude
        let startTime = String.stringFromDate(self.startTime)
        let endTime = String.stringFromDate(self.endTime)
        
        return jsonify([
            "id" ~~> id,
            "address" ~~> address,
            "laitude" ~~> latitude,
            "longitude" ~~> longitude,
            "startTime" ~~> startTime,
            "endTime" ~~> endTime,
            "items" ~~> items,
            "fromPrice" ~~> fromPrice,
            "toPrice" ~~> toPrice,
            "photos" ~~> photos,
            "owner" ~~> owner,
            "active" ~~> active
        ])
    }

}