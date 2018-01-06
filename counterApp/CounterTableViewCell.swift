//
//  CounterTableViewCell.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit

class CounterTableViewCell: UITableViewCell {

    let formatter = DateFormatter()
    
    @IBOutlet var counterNameLbl: UILabel!
    @IBOutlet var countdownLbl: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var dateLbl: UILabel!
    
    var counterDate = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCounter(date: Date) {
        formatter.dateFormat = "MMMM dd, yyyy HH:mm"
        dateLbl.text = formatter.string(from: date)
        counterDate = date
        Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
    }
    
    @objc func timerRunning() {
        let now = Date()
        let timeRemaining = (counterDate.timeIntervalSince(now))
        
        if (Int(timeRemaining) > 0)
        {
            let calendar = Calendar.current
            
            let diffDateComponents = calendar.dateComponents([.day , .hour , .minute , .second], from: now, to: counterDate)
            
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
            self.backgroundColor = UIColor.white
            countdownLbl.textColor = UIColor.black
            counterNameLbl.textColor = UIColor.black
        }
        else {
            countdownLbl!.text = String(0)
            self.backgroundColor = getColorByHex(rgbHexValue: 0xfc3d39)
            countdownLbl.textColor = UIColor.white
            counterNameLbl.textColor = UIColor.white
        }
    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    

}
