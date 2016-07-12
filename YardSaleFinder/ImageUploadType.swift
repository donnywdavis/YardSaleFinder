//
//  ImageUploadType.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 7/11/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation

enum ImageUploadType {
    case Profile
    case YardSale
    
    var imagePath: String {
        switch self {
        case .Profile:
            return "profile"
        case .YardSale:
            return "yardSale"
        }
    }
}
