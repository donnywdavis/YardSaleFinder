//
//  YardSale.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation
import Gloss


struct YardSale: Decodable {
    var id: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var fromTime: NSDate?
    var toTime: NSDate?
    var items: [String]?
    var fromPrice: Double?
    var toPrice: Double?
    var photos: [NSURL]?
    var active: Bool?
    var owners: [String]?
    var group: String?
    var created: NSDate?
    
    init?(json: JSON) {
        id = "id" <~~ json
        address = "address" <~~ json
        latitude = "latitude" <~~ json
        longitude = "longitude" <~~ json
        fromTime = NSDate.dateFromString("fromTime" <~~ json)
        toTime = NSDate.dateFromString("toTime" <~~ json)
        items = "items" <~~ json
        fromPrice = "fromPrice" <~~ json
        toPrice = "toPrice" <~~ json
        photos = "photos" <~~ json
        active = "active" <~~ json
        owners = "owners" <~~ json
        group = "group" <~~ json
        created = NSDate.dateFromString("created" <~~ json)
    }
}