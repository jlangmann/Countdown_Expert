//
//  CounterTableViewCell.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import UserNotifications

class CounterTableViewCell: UITableViewCell {

    let formatter = DateFormatter()
    
    @IBOutlet var counterNameLbl: UILabel!
    @IBOutlet var countdownLbl: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    
    var counterDate = Date()
    
    var hexColor:UInt32 = 0xffffff
    
    var sentNotification: Bool = false;
    var countdownTimer : Timer?
    
    let notificationAccess = "notificationAccess"
    let notifyOneWeek = "notifyOneWeek"
    let notifyOneDay = "notifyOneDay"
    let notifyOneHour = "notifyOneHour"


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteBtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupNotification(date: Date, key:String)
    {
        if (UserDefaults.standard.bool(forKey: key))
        {
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: self.counterNameLbl.text!, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Countdown completed! " + dateLbl.text!,
                                                                    arguments: nil)
         
            let calAdjust = Calendar.autoupdatingCurrent
            var countdownDate:Date = date;
            if (key == notifyOneWeek)
            {
                countdownDate = calAdjust.date(byAdding:.day, value: -7, to: date)!
            }
            else if (key == notifyOneDay)
            {
                countdownDate = calAdjust.date(byAdding:.day, value: -1, to: date)!
            }
            else if (key == notifyOneHour)
            {
                countdownDate = calAdjust.date(byAdding:.hour, value: -1, to:date)!
            }
            
            print("*** Countdowning to date: " + countdownDate.description)

            // Configure the trigger
            var dateInfo = DateComponents()
            let calendar = Calendar.current
            dateInfo.year = calendar.component(.year, from: date)
            dateInfo.day = calendar.component(.day, from: date)
            dateInfo.hour = calendar.component(.hour, from: date)
            dateInfo.minute = calendar.component(.minute, from: date)
            dateInfo.second = calendar.component(.second, from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
            
            // Create the request object.
            let request = UNNotificationRequest(identifier: "countdown" + self.counterNameLbl.text!, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }

    func setupCounter(date: Date) {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM dd, yyyy h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        dateLbl.text = formatter.string(from: date)
        counterDate = date
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
        
        if (UserDefaults.standard.bool(forKey: notificationAccess))
        {
            setupNotification(date:date, key:notificationAccess)
            setupNotification(date:date, key:notifyOneWeek)
            setupNotification(date:date, key:notifyOneDay)
            setupNotification(date:date, key:notifyOneHour)
        }
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
            if (hours != 0)
            {
                countdown = countdown + "\(hours) Hours"
            }
            if ((days == 0 || hours == 0) && (minutes != 0))
            {
                if (countdown != "")
                {
                    countdown += ", "
                }
                countdown = countdown + "\(minutes) Minutes"
            }
            if (days == 0 && hours == 0 && (seconds != 0))
            {
                if (countdown != "")
                {
                    countdown += ", "
                }
                countdown = countdown + "\(seconds) Seconds"
            }
            countdownLbl!.text = countdown
            self.backgroundColor = getColorByHex(rgbHexValue: hexColor)
            countdownLbl.textColor = UIColor.white
            counterNameLbl.textColor = UIColor.white
            deleteBtn.isHidden = true
        }
        else {
        
            deleteBtn.isHidden = false
            countdownLbl!.text = String(0)
            self.backgroundColor = getColorByHex(rgbHexValue: 0x000000)
            //self.backgroundColor = getColorByHex(rgbHexValue: 0xfc3d39)
            countdownLbl.textColor = UIColor.white
            counterNameLbl.textColor = UIColor.white
            
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
}
