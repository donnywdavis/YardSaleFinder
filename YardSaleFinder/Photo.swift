//
//  Photo.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 7/11/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

struct Photo {
    var image: UIImage?
    var name: String?
    
    func imageData() -> NSData? {
        guard let image = image else {
            return nil
        }
        
        return UIImagePNGRepresentation(image)
    }
}
