//
//  CounterTableViewCell.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit

class CounterTableViewCell: UITableViewCell {

    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var counterNameLbl: UILabel!
    @IBOutlet var countdownLbl: UILabel!
    @IBOutlet var img: UIImageView!
    
    var counterData = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCounter(date: Date) {
        counterData = date
        dateLbl!.text = date.description
        Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
    }
    
    @objc func timerRunning() {
        let now = Date()
        let timeRemaining = (counterData.timeIntervalSince(now))
        
        if (Int(timeRemaining) > 0)
        {
            let calendar = Calendar.current
            
            let diffDateComponents = calendar.dateComponents([.day , .hour , .minute , .second], from: now, to: counterData)
            
            let days = Int(diffDateComponents.day!)
            let hours = Int(diffDateComponents.hour!)
            let minutes = Int(diffDateComponents.minute!)
            let seconds = Int(diffDateComponents.second!)
            var countdown = ""
            if (days != 0)
            {
                countdown = "\(days) Days, "
            }
            if (days != 0 || (hours != 0))
            {
                countdown = countdown + "\(hours) Hours, "
            }
            if (days != 0 || hours != 0 || (minutes != 0))
            {
                countdown = countdown + "\(minutes) Minutes, "
            }
            if (days != 0  || hours != 0 || minutes != 0 || (seconds != 0))
            {
                countdown = countdown + "\(seconds) Seconds"
            }
            countdownLbl!.text = countdown
        }
        else {
            countdownLbl!.text = String(0)
        }
        
    }

}
