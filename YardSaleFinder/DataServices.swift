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

class DataServices: AnyObject {
    
    static var userProfile: Profile?
    static var usersYardSales: [YardSale]?
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
    
    class func getRemoteProfileData(uid: String, completion: (Profile?) -> Void) {
        DataReference.sharedInstance.usersRef.child(uid).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            guard let json = snapshot.value as? JSON else {
                completion(Profile())
                return
            }
            
            getYardSalesForOwner(uid, success: { (yardSales) in
                self.usersYardSales = yardSales
                }, failure: { (error) in
                    self.usersYardSales = [YardSale]()
            })
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
        newYardSale.annotation = Annotation(title: "Yard Sale", subtitle: newYardSale.address, coordinate: newYardSale.location!, id: newYardSale.id)
        DataServices.usersYardSales?.append(newYardSale)
        DataReference.sharedInstance.usersRef.child(DataServices.currentUser!.uid).child("yardSales").child(newKey).setValue(true)
        DataReference.sharedInstance.yardSalesRef.child(newKey).updateChildValues(newYardSale.toJSON()!)
        if newYardSale.active! {
            DataReference.sharedInstance.activeYardSalesRef.child(newKey).setValue(true)
        }
        
        completion()
    }
}
