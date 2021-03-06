//
//  YardSaleDateTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/23/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class YardSaleDateTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    
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

// MARK: Cell Configuration

extension YardSaleDateTableViewCell {
    
    func configureCell(dateString: String) {
        dateLabel.text = dateString
    }
    
}