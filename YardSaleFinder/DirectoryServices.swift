//
//  DirectoryServices.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/16/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class DirectoryServices: AnyObject {
    
    class func getDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    }
    
    class func getImagePath() -> String {
        return getDocumentsDirectory().URLByAppendingPathComponent("YardSaleFinder/profile.jpg").path!
    }
    
    class func getTempImagePath() -> String {
        return getDocumentsDirectory().URLByAppendingPathComponent("YardSaleFinder/temp_profile.jpg").path!
    }
    
    class func writeImageToDirectory(image: UIImage) {
        let newImage = UIImageJPEGRepresentation(image, 1.0)
        try! newImage?.writeToFile(getImagePath(), options: .DataWritingAtomic)
    }
    
    class func writeTempImageToDirectory(image: UIImage) {
        let newImage = UIImageJPEGRepresentation(image, 1.0)
        try! newImage?.writeToFile(getTempImagePath(), options: .DataWritingAtomic)
    }
    
    class func profileImageExists() -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(getImagePath())
    }
    
    class func tempProfileImageExists() -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(getTempImagePath())
    }
    
    class func removeImage() {
        try! NSFileManager.defaultManager().removeItemAtPath(getImagePath())
    }
    
    class func removeTempImage() {
        try! NSFileManager.defaultManager().removeItemAtPath(getTempImagePath())
    }
    
}