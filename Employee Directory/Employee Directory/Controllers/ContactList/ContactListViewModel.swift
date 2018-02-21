//
//  ContactListViewModel.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import Foundation
import Contacts

class ContactListViewModel {
    
    private var contactList = [Employee]()
    var groupedContactList = [(position:String,list:[CellRepresentable])]()
    var filtered:[CellRepresentable] = [CellRepresentable]()
    
    //MARK: - Events
    var errorInData: ((String) -> Void)?
    var updateView: (() -> Void)?
    var didSelectEmployee: ((Employee) -> Void)?
    var showContactPage: ((_ contact: CNContact) -> Void)?
    
    func fetchEmployeeData(){
        let request = BaseServiceRequest(
            method: .get,
            url: fetchURL()
        )
        
        let service = BaseService()
        service.makeRequest(request: request, success: { [weak self] json in
            guard let items = json["employees"] as? [[String : AnyObject]] else {
                self?.errorInData?(ServiceError.invalidResponse.description)
                return
            }
            self?.mapDataToModel(items: items)
        }) { [weak self] error in
            self?.errorInData?(error.localizedDescription)
        }
    }
    
    func fetchURL() -> String{
        let url = ServerBaseURL.baseURL.rawValue + EndpointURL.employeeList.rawValue
        return url
    }
    
    
    func mapDataToModel( items : [[String : AnyObject]]){
        for data in items{
            let employee = Employee.init(dictionary: data)
            let userContact = AddressBookManager.sharedInstance.findContactWithNameParameters(employee.fname, lname: employee.lname)
            if userContact != nil{
                employee.contact = userContact?.contactInfo
            }
            if !checkForContactInList(contact: employee){
                contactList.append(employee)
            }
        }
        generateHeaderAndRowSetForList()
    }
    
    func checkForContactInList(contact:Employee) -> Bool{
        let isThereList = contactList.filter{$0.contactDetails!.email! == contact.contactDetails!.email!}
        if isThereList.isEmpty{
            return false
        }
        return true
    }
    
    func generateHeaderAndRowSetForList(){
        var positions = contactList.map { $0.position}
        let uniqueSet = Set(positions)
        positions = Array(uniqueSet)
        let sortedPositions : [String] = positions.sorted { $0 < $1 }
        
        groupedContactList.removeAll()
        for position in sortedPositions {
            let empList = contactList.filter{$0.position == position}.sorted {$0.lname < $1.lname}
            let empRep : [CellRepresentable] = empList.map { viewModelFor(employee: $0) }
            groupedContactList.append((position: position, list: empRep))
        }
        updateView?()
    }
    
    func generateSetForSearchedString(searchText:String){
        let list = contactList.filter { contact in
            return checkContactAvailibility(contact:contact,text: searchText)
        }
        filtered = list.map { viewModelFor(employee: $0) }
        updateView?()
    }
    
    func checkContactAvailibility(contact:Employee, text:String) -> Bool {
        
        if contact.lname.lowercased().contains(text.lowercased()){
            return true
        }else if contact.fname.lowercased().contains(text.lowercased()){
            return true
        }else if  contact.position.lowercased().contains(text.lowercased()){
            return true
        }else if contact.contactDetails!.email?.lowercased().contains(text.lowercased()) == true{
            return true
        }else if contact.projects != nil{
            let itemList =  contact.projects!.filter { item in
                return item.lowercased().contains(text.lowercased())}
            return !(itemList.isEmpty)
        }
        return false
    }
    
    //MARK: - Helpers
    private func viewModelFor(employee: Employee) -> CellRepresentable {
        let viewModel = ContactsListCellViewModel.init(emp: employee)
        viewModel.didSelectEmployee = { [weak self] employee in
            self?.didSelectEmployee?(employee)
        }
        viewModel.showContactPage = { [weak self] contact in
            self?.showContactPage?(contact)
        }
        viewModel.errorInCell = { [weak self] error in
            self?.errorInData?(error.localizedDescription)
        }
        return viewModel
    }
    
    
}
