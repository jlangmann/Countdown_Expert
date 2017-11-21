//
//  Counter.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit

class Counter {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var date: Date
 
    init?(name: String, photo: UIImage?, date: Date) {
        
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.date = date
        
    }
}
