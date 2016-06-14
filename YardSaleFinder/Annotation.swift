//
//  Annotation.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/10/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var id: String?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, id: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.id = id
    }
}