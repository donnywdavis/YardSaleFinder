//
//  DataReference.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/9/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import Gloss
import GeoFire

class DataReference {
    
    static let sharedInstance = DataReference()
    
    // MARK: Reference Properties
    
    private let BASE_REF = FIRDatabase.database().reference()
    private let BASE_STORAGE_REF = FIRStorage.storage().referenceForURL("gs://yard-sale-finder.appspot.com")
    private let USERS_REF = FIRDatabase.database().reference().child("users")
    private let YARD_SALES_REF = FIRDatabase.database().reference().child("yardSales")
    private let ACTIVE_YARD_SALES_REF = FIRDatabase.database().reference().child("active")
    private let GROUPS_REF = FIRDatabase.database().reference().child("groups")
    private let GEOFIRE_REF = GeoFire(firebaseRef: FIRDatabase.database().reference().child("locations"))
    
    var baseRef: FIRDatabaseReference {
        return BASE_REF
    }
    
    var baseStorageRef: FIRStorageReference {
        return BASE_STORAGE_REF
    }
    
    var usersRef: FIRDatabaseReference {
        return USERS_REF
    }
    
    var yardSalesRef: FIRDatabaseReference {
        return YARD_SALES_REF
    }
    
    var activeYardSalesRef: FIRDatabaseReference {
        return ACTIVE_YARD_SALES_REF
    }
    
    var groupsRef: FIRDatabaseReference {
        return GROUPS_REF
    }
    
    var geoFireRef: GeoFire {
        return GEOFIRE_REF
    }
    
    
    // MARK: Reference Methods
    
    func userImagesRef(uid: String) -> FIRStorageReference {
        return baseStorageRef.child(uid).child("images")
    }
    
    func profileImageRef(uid: String) -> FIRStorageReference {
        return userImagesRef(uid).child("profile").child("profile.jpg")
    }
    
    func yardSaleImagesRef(uid: String) -> FIRStorageReference {
        return userImagesRef(uid).child("yardSale")
    }
    
}