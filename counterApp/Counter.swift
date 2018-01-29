//
//  Counter.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import os.log

class Counter: NSObject, NSCoding {
    
    //MARK: Properties
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let date = "date"
        static let time = "time"
        static let createdAt = "createdAt"
        static let bgColor = "backgroundColor"
    }
    
    // Archive properties
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("countDown")
    
    var name: String
    var photo: UIImage?
    var date: Date
    var time: Date
    var createdAt: Date
    var bgColor: UIColor

    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(createdAt, forKey: PropertyKey.createdAt)
        aCoder.encode(bgColor, forKey: PropertyKey.bgColor)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date
        let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date
        var createdAt = aDecoder.decodeObject(forKey: PropertyKey.createdAt) as? Date
        var bgColor = aDecoder.decodeObject(forKey: PropertyKey.bgColor) as? UIColor
        // Must call designated initializer.
        if (createdAt == nil)
        {
            createdAt = Date()
        }
        if (bgColor == nil)
        {
            bgColor = UIColor.white
        }
        self.init(name: name, photo: photo!, date: date!, time: time!, createdAt:createdAt!, bgColor:bgColor!)
    }
    
    init?(name: String, photo: UIImage?, date: Date, time: Date, createdAt: Date, bgColor: UIColor) {
        
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.photo = photo
        self.date = date
        self.time = time
        self.createdAt = createdAt
        self.bgColor = bgColor
    }
}
