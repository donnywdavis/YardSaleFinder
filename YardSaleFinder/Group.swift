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
    var yardSales: [String]?
    
    init?(json: JSON) {
        yardSales = "yardSales" <~~ json
    }
}