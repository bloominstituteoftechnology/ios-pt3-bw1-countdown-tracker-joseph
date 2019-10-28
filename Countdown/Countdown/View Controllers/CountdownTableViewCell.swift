//
//  CountdownTableViewCell.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/20/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit

class CountdownTableViewCell: UITableViewCell {

    @IBOutlet weak var countdownNameLabel: UILabel!
    
    var countdown: Countdown? {
        didSet {
            updateViews()
        }
    }
    //FIXME: create update views method
    private func updateViews() {
        guard let countdown = countdown else {return}
        countdownNameLabel.text = String("Note: \(countdown.name)")
    }

}
