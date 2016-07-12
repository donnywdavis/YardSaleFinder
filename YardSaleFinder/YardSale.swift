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

private let dateFormatter = NSDateFormatter()

struct YardSale: Decodable, Glossy {
    var id: String?
    var address: Address?
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
    
    var formattedDate: String {
        return "\(dateFormatter.formatDate(startTime)!)"
    }
    var formattedTime: String {
        return "\(formattedStartTime) - \(formattedEndTime)"
    }
    var formattedStartTime: String {
        return "\(dateFormatter.formatTime(startTime)!)"
    }
    var formattedEndTime: String {
        return "\(dateFormatter.formatTime(endTime)!)"
    }
    var formattedDateTime: String {
        return "\(formattedDate)\n\(formattedTime)"
    }
    
    init() {
        owner = DataServices.currentUser?.uid
    }
    
    init?(json: JSON) {
        id = "id" <~~ json
        if let addressJSON: JSON = "address" <~~ json {
            address = Address(json: addressJSON)
        }
        if let latitude: Double = "latitude" <~~ json, let longitude: Double = "longitude" <~~ json {
            location = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            location = nil
        }
        if location != nil {
            annotation = Annotation(title: "Yard Sale", subtitle: address?.oneLineDescription, coordinate: location!, id: id)
        }
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
        var latitude = 0.0
        var longitude = 0.0
        if location != nil {
            latitude = location!.latitude
            longitude = location!.longitude
        }
        let startTime = String.stringFromDate(self.startTime)
        let endTime = String.stringFromDate(self.endTime)
        
        return jsonify([
            "id" ~~> id,
            "address" ~~> address?.toJSON(),
            "latitude" ~~> latitude,
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
