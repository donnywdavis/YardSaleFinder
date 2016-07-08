//
//  DataServices.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/17/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import Gloss
import Firebase
import FirebaseAuth
import CoreLocation

enum BookmarkActions {
    case Add
    case Remove
}

class DataServices: AnyObject {
    
    static var userProfile: Profile?
    static weak var currentUser: FIRUser?
    
    class func isUserLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    class func signOut() {
        try! FIRAuth.auth()?.signOut()
        userProfile = nil
        currentUser = nil
    }
    
    class func setupUserProfileIfLoggedIn(completion: () -> Void) {
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            guard let user = user where currentUser == nil else {
                if auth.currentUser == nil {
                    completion()
                }
                return
            }
            
            updateCurrentUser(user)
            getRemoteProfileData(user.uid, completion: { (userProfile) in
                updateUserProfile(userProfile!)
                
                downloadProfileImage(user.uid, toPath: NSURL(fileURLWithPath: DirectoryServices.getImagePath()), completion: { (url, error) in
                    completion()
                })
            })
        })
    }
    
    class func updateCurrentUser(currentUser: FIRUser) {
        self.currentUser = currentUser
    }
    
    class func updateUserProfile(userProfile: Profile) {
        self.userProfile = userProfile
    }
    
    class func updateRemoteUserProfile(userProfile: Profile) {
        DataReference.sharedInstance.usersRef.child(userProfile.id!).updateChildValues(userProfile.toJSON()!)
    }
    
    class func getYardSalesForOwner(uid: String, success: ([YardSale]?) -> Void, failure: (String?) -> Void) {
        var yardSales = [YardSale]()
        
        DataReference.sharedInstance.yardSalesRef.queryOrderedByChild("owner").queryEqualToValue(uid).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
                failure("No yard sales found.")
                return
            }
            
            for (_, yardSale) in snapshotValue {
                yardSales.append(YardSale(json: yardSale as! JSON)!)
            }
            
            success(yardSales)
        }
    }
    
    class func addNewYardSale(yardSale: YardSale, completion: () -> Void) {
        var newYardSale = yardSale
        let newKey = DataReference.sharedInstance.yardSalesRef.childByAutoId().key
        newYardSale.id = newKey
        newYardSale.annotation = Annotation(title: "Yard Sale", subtitle: newYardSale.address?.oneLineDescription, coordinate: newYardSale.location!, id: newYardSale.id)
        DataReference.sharedInstance.usersRef.child(DataServices.currentUser!.uid).child("yardSales").child(newKey).setValue(true)
        DataReference.sharedInstance.yardSalesRef.child(newKey).updateChildValues(newYardSale.toJSON()!)
        if newYardSale.active! {
            DataReference.sharedInstance.activeYardSalesRef.child(newKey).setValue(true)
            DataReference.sharedInstance.geoFireRef.setLocation(CLLocation(latitude: newYardSale.location!.latitude, longitude: newYardSale.location!.longitude), forKey: newKey)
        }
        
        completion()
    }
    
    class func updateYardSale(yardSale: YardSale, completion: () -> Void) {
        var newYardSale = yardSale
        newYardSale.annotation = Annotation(title: "Yard Sale", subtitle: newYardSale.address?.oneLineDescription, coordinate: newYardSale.location!, id: newYardSale.id)
        DataReference.sharedInstance.yardSalesRef.child(newYardSale.id!).updateChildValues(newYardSale.toJSON()!)
        if newYardSale.active! {
            DataReference.sharedInstance.activeYardSalesRef.child(newYardSale.id!).setValue(true)
            DataReference.sharedInstance.geoFireRef.setLocation(CLLocation(latitude: newYardSale.location!.latitude, longitude: newYardSale.location!.longitude), forKey: newYardSale.id!)
        } else {
            DataReference.sharedInstance.activeYardSalesRef.child(newYardSale.id!).removeValue()
            DataReference.sharedInstance.geoFireRef.removeKey(newYardSale.id!)
        }
        
        completion()
    }
    
    class func deleteYardSale(yardSale: YardSale, completion: () -> Void) {
        if yardSale.active! {
            DataReference.sharedInstance.activeYardSalesRef.child(yardSale.id!).removeValue()
            DataReference.sharedInstance.geoFireRef.removeKey(yardSale.id)
        }
        DataReference.sharedInstance.usersRef.child(DataServices.currentUser!.uid).child("yardSales").child(yardSale.id!).removeValue()
        DataReference.sharedInstance.yardSalesRef.child(yardSale.id!).removeValue()
        completion()
    }
    
    class func getRemoteYardSaleInfo(uid: String, completion: (YardSale?) -> Void) {
        DataReference.sharedInstance.yardSalesRef.child(uid).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            guard let json = snapshot.value as? JSON, let yardSale = YardSale(json: json) else {
                completion(nil)
                return
            }
            
            completion(yardSale)
        }
    }
}

// MARK: Bookmark Methods

extension DataServices {
    
    class func bookmarkForUser(yardSaleID: String, action: BookmarkActions) {
        if !currentUserHasBookmarks() {
            userProfile?.bookmarks = [String: Bool]()
        }
        
        switch action {
        case .Add:
            DataServices.userProfile?.bookmarks![yardSaleID] = true
            DataReference.sharedInstance.usersRef.child(DataServices.currentUser!.uid).child("bookmarks").child(yardSaleID).setValue(true)
        case .Remove:
            DataServices.userProfile?.bookmarks?.removeValueForKey(yardSaleID)
            DataReference.sharedInstance.usersRef.child(DataServices.currentUser!.uid).child("bookmarks").child(yardSaleID).removeValue()
        }
    }
    
    class func currentUserHasBookmarks() -> Bool {
        guard let bookmarks = DataServices.userProfile?.bookmarks else {
            return false
        }
        return !bookmarks.isEmpty
    }
    
    class func yardSaleIsBookmarked(uid: String) -> Bool {
        guard let bookmark = DataServices.userProfile?.bookmarks?[uid] else {
            return false
        }
        return bookmark.boolValue
    }
    
}

// MARK: Image Methods

extension DataServices {
    
    class func getRemoteProfileData(uid: String, completion: (Profile?) -> Void) {
        DataReference.sharedInstance.usersRef.child(uid).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            guard let json = snapshot.value as? JSON else {
                completion(Profile())
                return
            }
            
            completion(Profile(json: json))
        }
    }
    
    class func downloadProfileImage(uid: String, toPath: NSURL, completion: (NSURL?, NSError?) -> Void) {
        DataReference.sharedInstance.profileImageRef(uid).writeToFile(toPath) { (url, error) in
            if error != nil && DirectoryServices.profileImageExists() {
                DirectoryServices.removeImage()
            }
            
            completion(url, error)
        }
    }
    
    class func uploadProfileImage(uid: String, fromPath: NSURL, completion: (FIRStorageMetadata?, NSError?) -> Void) {
        DataReference.sharedInstance.profileImageRef(uid).putFile(fromPath, metadata: .None) { (metadata, error) in
            completion(metadata, error)
        }
    }
    
    class func removeRemoteProfileImage(uid: String, completion: (NSError?) -> Void) {
        DataReference.sharedInstance.profileImageRef(uid).deleteWithCompletion { (error) in
            completion(error)
        }
    }
    
}
