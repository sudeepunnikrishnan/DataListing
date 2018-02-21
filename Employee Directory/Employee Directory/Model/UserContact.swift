//
//  UserContact.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 22/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import Foundation
import Contacts

struct UserContact {
    var fName : String?
    var lName : String?
    var name : String?
    var numbers : [String]?
    var emails : [String]?
    var contactInfo : CNContact?
}

extension UserContact {
//    @objc override func value(forKey key: String) -> Any? {
//        switch key {
//        case "fName":
//            return fName
//        case "lName":
//            return lName
//        case "name":
//            return name
//        case "numbers":
//            return numbers
//        case "emails":
//            return emails
//        default:
//            return nil
//        }
//    }
}
