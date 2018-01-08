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
    }
    
    // Archive properties
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("countDown")
    
    var name: String
    var photo: UIImage?
    var date: Date
    var time: Date
    var createdAt: Date

    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(createdAt, forKey: PropertyKey.createdAt)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date
        var createdAt = aDecoder.decodeObject(forKey: PropertyKey.createdAt) as? Date
        // Must call designated initializer.
        if (createdAt == nil)
        {
            createdAt = Date()
        }
        self.init(name: name, photo: photo!, date: date!, time: date!, createdAt:createdAt!)
    }
    
    init?(name: String, photo: UIImage?, date: Date, time: Date, createdAt: Date) {
        
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.date = date
        self.time = time
        self.createdAt = createdAt
    }
}
