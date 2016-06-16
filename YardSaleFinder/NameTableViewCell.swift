//
//  NameTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/16/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: Configure Cell

extension NameTableViewCell {
    
    func configureCell(userProfile: Profile?) {
        nameTextField.text = userProfile?.name
    }
    
}
