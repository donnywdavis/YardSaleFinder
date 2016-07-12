//
//  ImageHandler.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 7/11/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import Firebase

protocol ImageHandler {
    
}

extension ImageHandler {
    
    func updloadImage(yardSale: YardSale, photo: Photo, imageType: ImageUploadType, completion: (FIRStorageMetadata?, NSError?) -> Void) {
        guard let imageData = photo.imageData(), let imageName = photo.name, let owner = yardSale.owner, let yardSaleID = yardSale.id else {
            return
        }
        
        DataReference.sharedInstance.imagesRef(owner).child(imageType.imagePath).child(yardSaleID).child(imageName).putData(imageData, metadata: .None) { (metadata, error) in
            completion(metadata, error)
        }
    }
    
    func downloadImages(yardSale: YardSale, completion: (Photo?, error: NSError?) -> Void) {
        guard let photos = yardSale.photos else {
            return
        }
        
        for photoID in photos {
            DataReference.sharedInstance.photoRef(yardSale.owner!, yardSaleID: yardSale.id!, imageID: photoID).dataWithMaxSize(10 * 1024 * 1024, completion: { (data, error) in
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                completion(Photo(image: UIImage(data: data), name: photoID), error: nil)
            })
        }
    }
    
}
