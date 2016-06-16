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

class DataReference {
    
    static let sharedInstance = DataReference()
    
    private let BASE_REF = FIRDatabase.database().reference()
    private let BASE_STORAGE_REF = FIRStorage.storage().referenceForURL("gs://yard-sale-finder.appspot.com")
    private let USERS_REF = FIRDatabase.database().reference().child("users")
    private let YARD_SALES_REF = FIRDatabase.database().reference().child("yardSales")
    private let ACTIVE_YARD_SALES_REF = FIRDatabase.database().reference().child("active")
    private let GROUPS_REF = FIRDatabase.database().reference().child("groups")
    private var CURRENT_USER: FIRUser?
    private var USER_PROFILE: Profile?
    
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
    
    var currentUser: FIRUser? {
        if let user = CURRENT_USER {
            return user
        } else {
            return nil
        }
    }
    
    var userProfile: Profile? {
        return USER_PROFILE
    }
    
    var userStorageRef: FIRStorageReference {
        return baseStorageRef.child((currentUser?.uid)!)
    }
    
    var userImagesRef: FIRStorageReference {
        return userStorageRef.child("images")
    }
    
    var profileImageRef: FIRStorageReference {
        return userImagesRef.child("profile").child("profile.jpg")
    }
    
    var yardSaleImagesRef: FIRStorageReference {
        return userImagesRef.child("yardSale")
    }
    
    func setCurrentUserIfLoggedIn() {
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.CURRENT_USER = user
                self.usersRef.child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot: FIRDataSnapshot) in
                    guard let json = snapshot.value as? JSON else {
                        self.USER_PROFILE = Profile()
                        return
                    }
                    
                    self.USER_PROFILE = Profile(json: json)
                })
            }
        })
    }
    
    func signOut() {
        try! FIRAuth.auth()?.signOut()
        CURRENT_USER = nil
    }
    
    func updateUserProfile(userProfile: Profile?) {
        USER_PROFILE = userProfile
    }
    
}