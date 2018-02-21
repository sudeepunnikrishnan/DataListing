//
//  ContactsListCellViewModel.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class ContactsListCellViewModel{
    
    private var employee : Employee
    var name: String { guard let _ = employee.name else {return ""}
        return   "\(String(describing: employee.name!))" }
    
    var email: String { guard let _ = employee.contactDetails?.email else {return ""}
        return "\(String(describing: employee.contactDetails!.email!))"}
    var isContactAvailable: Bool { guard let _ = employee.contact else {return false}
        return true}
    var iconLetter : Character { return ((employee.lname != "") ?
        employee.lname.first : employee.name!.first)!  }
    var errorInCell: ((Error) -> Void)?
    var updateCell: ((ContactsListCellViewModel) -> Void)?
    var didSelectEmployee: ((Employee) -> Void)?
    var showContactPage: ((_ contact: CNContact) -> Void)?
    
    //MARK: - Lifecycle
    init(emp: Employee) {
        employee = emp
    }
    
    func contactAction(){
        showContactPage?(employee.contact!)
    }
}


extension ContactsListCellViewModel: CellRepresentable {
    static func registerCell(tableView: UITableView) {
        tableView.register(UINib(nibName:"ContactsListCell", bundle: nil), forCellReuseIdentifier:"ContactsListCell")
    }
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsListCell", for: indexPath) as! ContactsListCell
        cell.setup(viewModel: self)
        return cell
    }
    func cellSelected() {
        didSelectEmployee?(employee)
    }
}
