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
    
}
