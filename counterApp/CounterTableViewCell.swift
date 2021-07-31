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
    
    var counterDate = Date()
    
    var hexColor:UIColor = UIColor.white
    
    var sentNotification: Bool = false;
    var countdownTimer : Timer?
    
    let notificationAccess = "notificationAccess"
    let notifyOneWeek = "notifyOneWeek"
    let notifyOneDay = "notifyOneDay"
    let notifyOneHour = "notifyOneHour"


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupNotification(date: Date, key:String)
    {
        if (UserDefaults.standard.bool(forKey: key))
        {
            let calAdjust = Calendar.autoupdatingCurrent
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            var countdownDate:Date = date;
            
            content.title = NSString.localizedUserNotificationString(forKey: self.counterNameLbl.text!, arguments: nil)
            
            var message = "Countdown completed! " + dateLbl.text!
            if key == notifyOneWeek
            {
                message = "Countdown will be completed in 1 week: " + dateLbl.text!
                countdownDate = calAdjust.date(byAdding:.day, value: -7, to: date)!
            }
            else if key == notifyOneDay
            {
                message = "Countdown will be completed in 1 day: " + dateLbl.text!
                countdownDate = calAdjust.date(byAdding:.day, value: -1, to: date)!

            }
            else if key == notifyOneHour
            {
                message = "Countdown will be completed in 1 hour: " + dateLbl.text!
                countdownDate = calAdjust.date(byAdding:.hour, value: -1, to:date)!

            }
            content.body = NSString.localizedUserNotificationString(forKey: message,
                                                                    arguments: nil)

            // Configure the trigger
            var dateInfo = DateComponents()
            let calendar = Calendar.current
            dateInfo.year = calendar.component(.year, from: countdownDate)
            dateInfo.day = calendar.component(.day, from: countdownDate)
            dateInfo.hour = calendar.component(.hour, from: countdownDate)
            dateInfo.minute = calendar.component(.minute, from: countdownDate)
            dateInfo.second = calendar.component(.second, from: countdownDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
            
            // Create the request object.
            let identifier = self.counterNameLbl.text! + date.description + key
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }

    func setupCounter(date: Date) {
        formatter.dateFormat = "MMMM dd, yyyy h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        dateLbl.text = formatter.string(from: date)
        counterDate = date
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
        
        if (UserDefaults.standard.bool(forKey: notificationAccess))
        {
            let now:Date = Date()
            if now < date
            {
                setupNotification(date:date, key:notificationAccess)
                setupNotification(date:date, key:notifyOneWeek)
                setupNotification(date:date, key:notifyOneDay)
                setupNotification(date:date, key:notifyOneHour)
            }
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
                if days == 1
                {
                    countdown = "\(days) Day"
                }
                else {
                    countdown = "\(days) Days"
                }
            }
            if (hours != 0)
            {
                if (countdown != "")
                {
                    countdown += ", "
                }
                if hours == 1
                {
                    countdown = countdown + "\(hours) Hour"
                }
                else
                {
                    countdown = countdown + "\(hours) Hours"
                }
            }
            if ((days == 0 || hours == 0) && (minutes != 0))
            {
                if (countdown != "")
                {
                    countdown += ", "
                }
                if minutes == 1
                {
                    countdown = countdown + "\(minutes) Minute"
                }
                else {
                    countdown = countdown + "\(minutes) Minutes"
                }
            }
            if (days == 0 && hours == 0 && (seconds != 0))
            {
                if (countdown != "")
                {
                    countdown += ", "
                }
                if seconds == 1
                {
                    countdown = countdown + "\(seconds) Second"
                }
                else
                {
                    countdown = countdown + "\(seconds) Seconds"
                }
            }
            countdownLbl!.text = countdown
            self.backgroundColor = hexColor
            countdownLbl.textColor = UIColor.white
            counterNameLbl.textColor = UIColor.white
        }
        else {
            countdownLbl!.text = String(0)
            self.backgroundColor = UIColor.black
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
