//
//  User.swift
//  touch-id-example
//
//  Created by Victor Baleeiro on 24/10/17.
//  Copyright © 2017 Going2. All rights reserved.
//

import UIKit
import os.log

class User: NSObject, NSCoding {
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: Properties
    //-------------------------------------------------------------------------------------------------------------
    let isLogged: Bool
    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: Types
    //-------------------------------------------------------------------------------------------------------------
    struct PropertyKey {
        static let isLogged = "isLogged"
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: Initialization
    //-------------------------------------------------------------------------------------------------------------
    init?(isLogged: Bool) {
        
        //Initialize stored properties.
        self.isLogged = isLogged
    }
    
    
    //-------------------------------------------------------------------------------------------------------------
    //MARK: Archiving Paths
    //-------------------------------------------------------------------------------------------------------------
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users")
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isLogged, forKey: PropertyKey.isLogged)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The property isLogged is required. If we cannot decode a isLogged string, the initializer should fail.
        guard let isLogged = aDecoder.decodeObject(forKey: PropertyKey.isLogged) as? Bool else {
            os_log("Unable to decode the isLogged for a User.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(isLogged: isLogged)
    }
}
