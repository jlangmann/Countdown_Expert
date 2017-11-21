//
//  CounterTableViewCell.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit

class CounterTableViewCell: UITableViewCell {

    @IBOutlet var counterNameLbl: UILabel!
    @IBOutlet var countdownLbl: UILabel!
    @IBOutlet var img: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
