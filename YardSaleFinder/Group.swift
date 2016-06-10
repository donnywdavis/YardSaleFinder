//
//  Group.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation
import Gloss

struct Group: Decodable {
    var id: String?
    var yardSales: [String]?
    
    init?(json: JSON) {
        id = "id" <~~ json
        yardSales = "yardSales" <~~ json
    }
}