//
//  DataReference.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation
import Firebase


class DataReference {
    
    static let sharedInstance = DataReference()
    
    private let BASE_REF = FIRDatabase.database().reference()
    private let USERS_REF = FIRDatabase.database().reference().child("users")
    private let YARD_SALES_REF = FIRDatabase.database().reference().child("yardSales")
    private let GROUPS_REF = FIRDatabase.database().reference().child("groups")
    
    var baseRef: FIRDatabaseReference {
        return BASE_REF
    }
    
    var usersRef: FIRDatabaseReference {
        return USERS_REF
    }
    
    var yardSalesRef: FIRDatabaseReference {
        return YARD_SALES_REF
    }
    
    var groupsRef: FIRDatabaseReference {
        return GROUPS_REF
    }
    
}