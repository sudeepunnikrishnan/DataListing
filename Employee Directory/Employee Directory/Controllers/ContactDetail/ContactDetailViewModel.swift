//
//  ContactDetailViewModel.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import Foundation
import Contacts

class ContactDetailViewModel {
    
    private let employee: Employee
    
    var name: String { guard let _ = employee.name else {return ""}
        return   "\(String(describing: employee.name!))" }
    var position: String { return employee.position
    }
    var email: String { guard let _ = employee.contactDetails?.email else {return ""}
        return "\(String(describing: employee.contactDetails!.email!))"}
    var isContactAvailable: Bool { guard let _ = employee.contact else {return false}
        return true}
    var iconLetter : String { return shortNameForLabel()  }
    var mobile: String { guard let _ = employee.contactDetails?.phone else {return "-"}
        return "\(String(describing: employee.contactDetails!.phone!))"}
    var projectCount: String { guard let _ =  employee.projects else {return "0"}
        return "\(employee.projects!.count)"
    }
    var projects: [String]? { guard let _ =  employee.projects else {return nil}
        return employee.projects!}
    var contact: CNContact? { guard let _ =  employee.contact else {return nil}
        return employee.contact! }
    
    //MARK: - Lifecycle
    init(employee: Employee) {
        self.employee = employee
    }
    
    func shortNameForLabel() -> String {
        if employee.lname != "" && employee.fname != ""{
            return String(describing: employee.lname.first!) + String(describing: employee.fname.first!)
            
        }else if employee.name != nil {
            return String(describing: employee.name!.first!)
        }else{
            return ""
        }
    }
}
