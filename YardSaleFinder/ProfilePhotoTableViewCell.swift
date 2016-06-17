//
//  ProfilePhotoTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/15/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class ProfilePhotoTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0).CGColor
        profileImageView.layer.borderWidth = 4.0
        profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: Configure Cell

extension ProfilePhotoTableViewCell {
    
    func configureCell(userProfile: Profile?) {
        guard DirectoryServices.profileImageExists() else {
            profileImageView.image = UIImage(named: "profile100")
            return
        }
        
        profileImageView.image = UIImage(contentsOfFile: DirectoryServices.getImagePath())
    }
    
    func setProfilePhoto(photo: UIImage) {
        profileImageView.image = photo
    }
    
}