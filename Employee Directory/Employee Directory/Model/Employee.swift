//
//  Employee.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//


import Contacts

private struct SerializationKeys {
    static let position = "position"
    static let contactDetails = "contact_details"
    static let projects = "projects"
    static let fname = "fname"
    static let lname = "lname"
    static let phone = "phone"
    static let email = "email"
}

class Employee: NSObject {

    // MARK: Properties
    public var position = ""
    public var contactDetails: ContactDetails?
    public var projects: [String]?
    public var fname = ""
    public var lname = ""
    var name:String?
    var contact: CNContact?
    
    init(dictionary:[String:AnyObject]) {
        if let pos = dictionary[SerializationKeys.position] as? String {
            position = pos
        }
       
        if let lname = dictionary[SerializationKeys.lname] as? String {
            self.lname = lname
            name = self.lname
        }
        
        if let fname = dictionary[SerializationKeys.fname] as? String {
            self.fname = fname
            if(name != nil){
                name = name! + " " + self.fname
            }else{
                name = self.fname
            }
        }
        
        if let projects = dictionary[SerializationKeys.projects] as? [String] {
            self.projects = projects
        }
        if let contactDetails = dictionary[SerializationKeys.contactDetails] as? [String:AnyObject] {
            self.contactDetails = ContactDetails.init(dictionary: contactDetails)
        }
    }
}

class ContactDetails: NSObject {
    public var phone: String?
    public var email: String?
    
    init(dictionary:[String:AnyObject]){
        if let phone = dictionary[SerializationKeys.phone] as? String {
            self.phone = phone
        }
        if let email = dictionary[SerializationKeys.email] as? String {
            self.email = email
        }
    }
}

