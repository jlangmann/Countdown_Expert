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
    }
    
    // Archive properties
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("countDown")
    
    var name: String
    var photo: UIImage?
    var date: Date
 
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(date, forKey: PropertyKey.date)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date
        // Must call designated initializer.
        self.init(name: name, photo: photo!, date: date!)
    }
    
    init?(name: String, photo: UIImage?, date: Date) {
        
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.date = date
        
    }
}
