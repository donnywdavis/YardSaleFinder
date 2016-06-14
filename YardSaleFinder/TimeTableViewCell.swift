//
//  TimeTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var timeLabel: UILabel!
    
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

extension TimeTableViewCell {
    
    func configureCell(yardSale: YardSale) {
        timeLabel.text = "08:00 - 12:00"
    }
    
}